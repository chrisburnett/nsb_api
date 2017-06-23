class Assignment < ApplicationRecord
  has_paper_trail # versioning/auditing

  belongs_to :user
  belongs_to :job
  belongs_to :contractor, class_name: "User"

  validates_presence_of :job_id
  validates :status, inclusion: { in: %w(pending accepted rejected cancelled).push(nil) }
  before_create :set_assignment_date

  # active assignments are the latest accepted assignments on open jobs
  scope :active, -> { includes(:job)
                      .where(status: "accepted", jobs: { completed: false })
                      .order("job_id, assignment_date DESC") 
                      .select("DISTINCT ON(job_id) *") }

  def active
    status == "accepted" &&
      !job.completed &&
      id == job.assignments.order('assignment_date DESC').first.id
  end

  private

  def set_assignment_date
    self.assignment_date = Time.now
  end
  def set_response_date
    self.response_date = Time.now
  end

end
