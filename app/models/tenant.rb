class Tenant < ApplicationRecord

  has_many :jobs
  
  validates_presence_of :name
  validates_presence_of :address

end
