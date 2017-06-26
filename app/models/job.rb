class Job < ApplicationRecord
  has_paper_trail # versioning/auditing

  has_many :assignments, dependent: :destroy
  has_one :latest_assignment, class_name: "Assignment"

  has_many :job_comments, dependent: :destroy
  belongs_to :user
  belongs_to :tenant
  
  validates_presence_of :short_title
  validates_presence_of :reported_date

  mount_uploader :signature, SignatureUploader 

  scope :open, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
  # job considered assigned if it has a latest assignment and that
  # assignment is accepted
  def assigned
    !latest_assignment.nil? && latest_assignment.status == 'accepted'
  end

  def status
    completed || (latest_assignment.status || 'pending')
  end

end
