class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates_presence_of :assignment_date
  validates_presence_of :job_id
end
