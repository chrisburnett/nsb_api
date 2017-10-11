class Assignment < ApplicationRecord
  include AASM

  @@json_template = { include: { attachments: {}, job: { include: :tenant } } }
  has_paper_trail # versioning/auditing

  belongs_to :user
  belongs_to :job
  belongs_to :contractor, class_name: "User"

  has_many :attachments, inverse_of: :assignment, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  
  validates_presence_of :job_id

  before_create :set_assignment_date
  after_create :update_job_latest_assignment, :notify_assignment_created
  after_update :notify_assignment_changes
  after_destroy :notify_assignment_cancelled
  before_save :set_scheduled_time
  after_save :broadcast
  
  # allow signatures to be uploaded
  mount_uploader :signature, SignatureUploader 

  scope :latest, -> { joins(:job).where( 'assignments.id = jobs.latest_assignment_id') }
  scope :with_open_job, -> { joins(:job).where.not( jobs: { status: Job::STATE_COMPLETED }) }
  scope :active, -> { where( status: [Assignment::STATE_PENDING, Assignment::STATE_ACCEPTED] ) }
  # state machine
  aasm column: 'status' do

    after_all_events :update_job_state

    state :pending, initial: true
    state :accepted, :rejected, :cancelled, :fulfilled

    event :accept do
      transitions from: :pending, to: :accepted
    end
    event :reject do
      transitions from: [:pending, :accepted], to: :rejected
    end
    event :cancel do
      transitions from: [:pending, :accepted], to: :cancelled, after: :notify_assignment_cancelled
    end
    event :fulfil do
      transitions from: :accepted, to: :fulfilled
    end
    
  end

  # on state transition
  def update_job_state
    if job.latest_assignment&.id == id then
      #if accepted? then job.assign!
      if (rejected? || cancelled?) && job.may_unassign? then job.unassign!
      elsif fulfilled? then job.review!
      end
    end
  end
  
  def active?
    id == job.latest_assignment&.id && (accepted? || pending?) && !job.completed?
  end

  def status=(status)
    # validation hack - declarative validations don't seem to play with aasm
    raise ActiveRecord::RecordInvalid unless
      %w(pending accepted rejected cancelled fulfilled).include?(status)
    
    if(status == Assignment::STATE_ACCEPTED.to_s) then accept!
    elsif(status == Assignment::STATE_REJECTED.to_s) then reject!
    elsif(status == Assignment::STATE_CANCELLED.to_s) then cancel!
    elsif(status == Assignment::STATE_FULFILLED.to_s) then fulfil!
    end
  end
  
  private
  
  def broadcast
    job.broadcast
  end
  
  # after create
  def update_job_latest_assignment
    # if there's a currently active assignment, cancel it
    if job.latest_assignment&.pending? || job.latest_assignment&.accepted? then
      job.latest_assignment.cancel!
    end
    job.update(latest_assignment_id: self.id)
    if job.may_assign? then job.assign! end
  end

  def set_scheduled_time
    if self.am_pm_visit != "Specific time"
      self.scheduled_hour = nil
      self.scheduled_minute = nil
    end
  end
  
  def set_assignment_date
    self.assignment_date = Time.now
  end
  
  def set_response_date
    self.response_date = Time.now
  end

  # send push notifications as required we are using the Push API to
  # send out notifications immediately. Notifications are not going to
  # be high frequency so we don't need the separate daemon running
  
  def notify_assignment_created
    registration_id = self.contractor.registration_id
    if registration_id then
      title = 'New job assignment'
      message = "Tap for more details."
      data = self.as_json(@@json_template)
      FCMNotifier.push(title, message, registration_id, data)
    end
  end

  def notify_assignment_cancelled
    registration_id = self.contractor.registration_id
    if registration_id then
      title = 'Assignment cancelled'
      message = "Tap for more details."
      data = self.as_json(@@json_template)
      FCMNotifier.push(title, message, registration_id, data)
    end
  end

  def notify_assignment_changes
    changes = self.changes.except(:user_id, :job_id, :created_at, :updated_at, :status, :signature)
    registration_id = self.contractor.registration_id

    # only if there's a device registered, something has changed and the assignment is active
    if registration_id && !changes.empty? && active? then
      title = 'Assignment updated'
      message = ''
      changes.each do |k,v|
        message << "#{k.capitalize} changed to: #{v[1]}"
      end
      data = self.as_json(@@json_template)
      FCMNotifier.push(title, message, registration_id, data)
    end
  end
  
end
