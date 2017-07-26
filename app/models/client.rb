class Client < ApplicationRecord
  has_many :jobs, inverse_of: :client
end
