class Job < ApplicationRecord
  has_paper_trail # versioning/auditing
  
  has_many :assignments, dependent: :destroy
  has_many :job_comments, dependent: :destroy
  has_many :items, inverse_of: :job, dependent: :destroy

  belongs_to :latest_assignment, class_name: "Assignment", foreign_key: :latest_assignment_id, optional: true
  belongs_to :user
  belongs_to :tenant
  belongs_to :client
  belongs_to :priority
  
  validates_presence_of :short_title
  validates_presence_of :reported_date
  validates_presence_of :tenant_id
  validates_presence_of :client_id

  accepts_nested_attributes_for :items
  
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
