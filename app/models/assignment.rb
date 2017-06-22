class Assignment < ApplicationRecord
  has_paper_trail # versioning/auditing

  belongs_to :user
  belongs_to :job
  belongs_to :contractor, class_name: "User"

  validates_presence_of :job_id

  before_create :set_assignment_date
  before_save :update_job_status
  
  scope :active, -> { includes(:job)
                      .where(status: "accepted", jobs: { assigned: true, completed: false })
                      .order("job_id, assignment_date DESC") 
                      .select("DISTINCT ON(job_id) *") }

  def active
    status == "accepted" &&
      job.assigned &&
      !job.completed &&
      id == job.assignments.order('assignment_date DESC').first.id
  end

  private

  def set_assignment_date
    self.assignment_date = Time.now
  end

  def update_job_status
    # if the current most recent task changes state, update job to reflect
    # rejecting the current assignment returns job to unassigned status
    if id == job.try(:latest_assignment).try(:id) && status_changed? then
      if status == "accepted" then
        job.update_attribute(:assigned, true)
      elsif status == "rejected" || status == nil then
        job.update_attribute(:assigned, false)
      end
    end
  end
end
