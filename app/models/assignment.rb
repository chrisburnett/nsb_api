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

end
