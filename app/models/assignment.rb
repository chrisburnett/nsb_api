class Assignment < ApplicationRecord
  has_paper_trail # versioning/auditing

  belongs_to :user
  belongs_to :job
  belongs_to :contractor, class_name: "User"

  validates_presence_of :job_id
  validates :status, inclusion: { in: %w(pending accepted rejected cancelled fulfilled).push(nil) }

  before_create :set_assignment_date
  before_create :set_status
  after_create :update_job_latest_assignment
  before_update :unlink_job_if_necessary, :if => :status_changed?
  
  # allow signatures to be uploaded
  mount_uploader :signature, SignatureUploader 
  
  def active
    status == "accepted" &&
      !job.completed &&
      id == job.latest_assignment&.id
  end

  private

  def set_status
    self.status ||= "pending"
  end

  # after create
  def update_job_latest_assignment
    # if there's a currently active assignment, cancel it
    if %w(pending accepted).include?(job.latest_assignment&.status) then
      job.latest_assignment.update(status: "cancelled")
    end
    job.update(latest_assignment_id: id)
  end
  
  def set_assignment_date
    self.assignment_date = Time.now
  end
  
  def set_response_date
    self.response_date = Time.now
  end

  # before updating status if this is the current assignment and it's
  # being fulfilled, unlink it (leaving the job unassigned)
  def unlink_job_if_necessary
    if %w(fulfilled).include?(self.status) &&
       self.job.latest_assignment.id == self.id then
      self.job.update(latest_assignment: nil)
    end
  end

end
