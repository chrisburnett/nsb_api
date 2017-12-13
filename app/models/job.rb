require 'csv'

class Job < ApplicationRecord
  include AASM

  @@json_template = { include: :tenant }
  
  has_paper_trail # versioning/auditing
  
  has_many :assignments, dependent: :destroy
  has_many :job_comments, dependent: :destroy
  has_many :items, inverse_of: :job, dependent: :destroy, after_add: :notify_assignments_items_changed, after_remove: :notify_assignments_items_changed
  has_many :attachments, through: :assignments

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
  belongs_to :trade
  
  validates_presence_of :job_number
  
  validates_presence_of :reported_date
  validates_presence_of :tenant_id
  validates_presence_of :client_id

  accepts_nested_attributes_for :items, allow_destroy: true
  accepts_nested_attributes_for :client, :tenant
  
  mount_uploader :signature, SignatureUploader

  after_update :update_invoiced_state, :notify_assignments
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
      transitions from: [:unassigned, :assigned, :completed], to: :review
    end

    # can only invoice a completed job (may be too restrictive)
    # no return from invoiced - need to create new job, can't reopen
    event :invoice do
      transitions from: [:completed], to: :invoiced, guard: :all_related_completed
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

  def all_related_completed
    Job.where(job_number: job_number).where.not(status: ["completed", "invoiced"]).length == 0
  end
  
  private

  def update_invoiced_state
    if !invoice_number.nil? && status != Job::STATE_INVOICED && may_invoice? then
      invoice!
    end
  end

  def notify_assignments
    changes = self.changes.except(:user_id, :signature, :status, :invoice_number, :created_at, :updated_at, :latest_assignment_id)
    registration_id = self.latest_assignment&.contractor&.registration_id
    
    if registration_id && !changes.empty? && latest_assignment.active? then
      title = "Assignment updated"
      message = ''
      changes.each do |k,v|
        message << "Job #{k} changed to: #{v[1]}"
      end
      data = self.as_json(@@json_template)
      FCMNotifier.push(title, message, registration_id, data)
    end

  end

  def notify_assignments_items_changed(item)
    # ignore unsaved objects created by Cocoon
    if(!item.id.nil?)
      registration_id = self.latest_assignment&.contractor&.registration_id
      
      if registration_id && latest_assignment.active? then
        title = "Assignment updated"
        message = "Materials/labour changed: #{item.description} (#{item.quantity})"
        data = self.as_json(@@json_template)
        FCMNotifier.push(title, message, registration_id, data)
      end
    end
  end

  def self.to_csv
    attributes = %w{job_number trade client_id client_name tenant_id tenant_name tenant_address user_id user_name priority status invoice_number due_date reported_date completed_date reported_fault job_notes latest_assignment_contractor_id latest_assignment_contractor_name latest_assignment_date_assigned latest_assignment_date_scheduled latest_assignment_date_actual latest_assignment_scheduled_hour latest_assignment_scheduled_minute latest_assignment_resolution latest_assignment_notes}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      # possibly requiring large number of joins
      all.each do |job|
        csv << [job.job_number, job.trade&.name, job.client.id, job.client.name, job.tenant.id, job.tenant.name, job.tenant.address, job.user.id, job.user.name, job.priority.priority, job.status, job.invoice_number, job.due_date, job.reported_date, job.completed_date, job.reported_fault, job.notes, job.latest_assignment.contractor.id, job.latest_assignment.contractor.name, job.latest_assignment.assignment_date, job.latest_assignment.scheduled_date, job.latest_assignment.actual_date, job.latest_assignment.scheduled_hour, job.latest_assignment.scheduled_minute, job.latest_assignment.resolution, job.latest_assignment.notes]
      end
    end
  end

end
