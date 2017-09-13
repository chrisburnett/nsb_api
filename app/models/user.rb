class User < ApplicationRecord
  has_paper_trail # versioning/auditing
  
  has_many :jobs
  has_many :job_comments
  has_many :assignments, foreign_key: :contractor_id, source: :assignment
  has_many :created_assignments, foreign_key: :user_id, source: :assignment
  
  has_secure_password
  validates_confirmation_of :password

  validates_presence_of :name
  validates_presence_of :username
  validates :username, uniqueness: true

  before_create { |user| user.active = true }
  
  def generate_auth_token
    payload = { user_id: self.id }
    Authentication::AuthToken.encode(payload)
  end

  def active_assignments
    assignments.includes(:job).where(status: "accepted", jobs: { completed: false })
  end
  
  def pending_assignments
    assignments.includes(:job).where(status: "pending", jobs: { completed: false })
  end

end
