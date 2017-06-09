class User < ApplicationRecord

  has_many :jobs
  
  has_secure_password
  validates_presence_of :name
  validates_presence_of :address

end
