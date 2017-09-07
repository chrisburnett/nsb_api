class Job < ApplicationRecord
  include AASM

  @@json_template = { include: :tenant }
  @FCMNotifier = FCMNotifier.new
  
  has_paper_trail # versioning/auditing
  
  has_many :assignments, dependent: :destroy
  has_many :job_comments, dependent: :destroy
  has_many :items, inverse_of: :job, dependent: :destroy

  # touch true will touch latest assignment when job changes we do
  # this because we are often sending out latest_assignment+job to
  # client, so consider them indivisible. Any changes to the job
  # should be communicated to the contractor
  belongs_to :latest_assignment, class_name: "Assignment", foreign_key: :latest_assignment_id, optional: true
  has_one :contractor, through: :latest_assignment, source: :contractor

  belongs_to :user
  # touch job when tenant/client changes, will in turn touch latest_assignment
  belongs_to :tenant, inverse_of: :jobs
  belongs_to :client, inverse_of: :jobs
  belongs_to :priority
  
  validates_presence_of :job_number
  validates_uniqueness_of :job_number
  
  validates_presence_of :reported_date
  validates_presence_of :tenant_id
  validates_presence_of :client_id

  accepts_nested_attributes_for :items, allow_destroy: true
  accepts_nested_attributes_for :client, :tenant
  
  mount_uploader :signature, SignatureUploader

  before_save :update_invoiced_state, :notify_assignments
  after_save :broadcast

  aasm column: 'status' do
    state :unassigned, intitial: true
    state :assigned
    state :review
    state :completed
    state :invoiced

    # allowed to reassign over existing assignment
    event :assign do
      transitions from: [:assign, :unassigned, :review], to: :assigned
    end
    event :unassign do
      transitions from: :assigned, to: :unassigned
    end
    # always allowed to mark as complete
    event :complete do
      transitions from: [:unassigned, :assigned, :review], to: :completed
    end
    # review state occurs when the assignment is fulfilled and the job
    # needs to be reviewed to see whether further assignment required
    event :review do
      transitions from: [:assigned, :completed], to: :review
    end

    # can only invoice a completed job (may be too restrictive)
    # no return from invoiced - need to create new job, can't reopen
    event :invoice do
      transitions from: [:completed], to: :invoiced
    end
    
    # allow reopening of closed jobs without requiring new job created
    event :reopen do
      transitions from: [:completed], to: :unassigned
    end
    
  end
  
  def status=(status)
    if(status == Job::STATE_UNASSIGNED.to_s && may_reopen?) then reopen!
    elsif(status == Job::STATE_COMPLETED.to_s) then complete!
    elsif(status == Job::STATE_REVIEW.to_s) then review!
    end
  end

  def broadcast
    begin
      ActionCable.server.broadcast(
        'jobs',
        job: self
      )
    rescue
    end
  end

  private

  def update_invoiced_state
    if !invoice_number.nil? && status != Job::STATE_INVOICED && may_invoice? then
      invoice!
    end
  end

  def notify_assignments
    changes = self.changes.except(:user_id, :signature, :status, :invoice_number, :created_at, :updated_at)
    registration_id = self.latest_assignment&.contractor&.registration_id
    
    if registration_id && !changes.empty? && latest_assignment.active? then
      title = "Assignment updated"
      message = ''
      changes.each do |k,v|
        message << "Job #{k} changed to: #{v[1]}"
      end
      data = self.as_json(@@json_template)
      @FCMNotifier.push(title, message, registration_id, data)
    end

  end

end
