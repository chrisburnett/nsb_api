class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates_presence_of :assignment_date
  
end
