class Client < ApplicationRecord
  has_many :jobs, inverse_of: :client

  validates_presence_of :name
  validates_presence_of :address
end
