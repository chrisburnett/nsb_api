class Job < ApplicationRecord
  belongs_to :tenant
  belongs_to :user

  has_one :current_assignment
  
  validates_presence_of :short_title
  validates_presence_of :reported_date

end
