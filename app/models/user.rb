class User < ApplicationRecord
  has_paper_trail # versioning/auditing
  
  has_many :jobs
  has_many :job_comments
  has_many :assignments
  
  has_secure_password
  validates_presence_of :name
  validates_presence_of :address

  def generate_auth_token
    payload = { user_id: self.id }
    Authentication::AuthToken.encode(payload)
  end

end
