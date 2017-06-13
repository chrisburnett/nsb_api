class Job < ApplicationRecord
  has_many :assignments
  belongs_to :user
  belongs_to :tenant
  
  validates_presence_of :short_title
  validates_presence_of :reported_date

  scope :available, -> { where(assigned: false) }
  scope :open, -> { where(completed: false) }

end
