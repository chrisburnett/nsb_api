class Tenant < ApplicationRecord

  has_many :jobs, inverse_of: :tenant
  
  validates_presence_of :name
  validates_presence_of :address

end
