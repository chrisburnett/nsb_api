class Job < ApplicationRecord
  has_paper_trail # versioning/auditing

  has_many :assignments, dependent: :destroy
  has_many :job_comments, dependent: :destroy
  belongs_to :user
  belongs_to :tenant
  
  validates_presence_of :short_title
  validates_presence_of :reported_date

  scope :accepted, -> { where(status: "accepted") }
  scope :assigned, -> { where(assigned: true) }

  mount_uploader :signature, SignatureUploader 
  
  def latest_assignment
    assignments.order('assignment_date DESC').first
  end
end
