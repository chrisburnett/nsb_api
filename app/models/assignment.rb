class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates_presence_of :assignment_date
  validates_presence_of :job_id

  # open assignments are ones which are currently assigned and haven't
  # been completed yet
  # NOTE: DOESN'T WORK IN POSTGRES, PSQL SOLUTION BELOW
  # scope :active, -> { joins(:job)
  #                   .where(jobs: { assigned: true, completed: false })
  #                   .group(:id, :job_id)
  #                   .having('assignment_date = MAX(assignment_date)')
  #     }

  # PostgreSQL version - select the first row from each group ordered by date
  scope :active, -> { includes(:job)
                      .where(jobs: { assigned: true, completed: false })
                      .order("job_id, assignment_date DESC") 
                      .select("DISTINCT ON(job_id) *") }

  def active
    job.assigned && !job.completed && id == job.assignments.order('assignment_date DESC').first.id
  end

end
