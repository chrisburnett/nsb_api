class Job < ApplicationRecord
  has_paper_trail # versioning/auditing

  has_many :assignments, dependent: :destroy
  has_many :job_comments, dependent: :destroy
  belongs_to :user
  belongs_to :tenant
  
  validates_presence_of :short_title
  validates_presence_of :reported_date

  mount_uploader :signature, SignatureUploader 

  # job considered assigned if it has a latest assignment and that
  # assignment is accepted
  def assigned
    !latest_assignment.nil? && latest_assignment.status == 'accepted'
  end
  
  def latest_assignment
    assignments.order('assignment_date DESC').first
  end
end
