class Job < ApplicationRecord
  include AASM
  
  has_paper_trail # versioning/auditing
  
  has_many :assignments, dependent: :destroy
  has_many :job_comments, dependent: :destroy
  has_many :items, inverse_of: :job, dependent: :destroy

  belongs_to :latest_assignment, class_name: "Assignment", foreign_key: :latest_assignment_id, optional: true
  has_one :contractor, through: :latest_assignment, source: :contractor

  belongs_to :user
  belongs_to :tenant
  belongs_to :client
  belongs_to :priority
  
  validates_presence_of :short_title
  validates_presence_of :reported_date
  validates_presence_of :tenant_id
  validates_presence_of :client_id

  accepts_nested_attributes_for :items, allow_destroy: true
  
  mount_uploader :signature, SignatureUploader

  after_save :broadcast

  aasm column: 'status' do
    state :unassigned, intitial: true
    state :assigned
    state :review
    state :completed

    # allowed to reassign over existing assignment
    event :assign do
      transitions from: [:assign, :unassigned, :review], to: :assigned
    end
    event :unassign do
      transitions from: :assigned, to: :unassigned
    end
    # always allowed to mark as complete
    event :complete do
      transitions from: [:unassigned, :assigned, :review], to: :completed
    end
    # review state occurs when the assignment is fulfilled and the job
    # needs to be reviewed to see whether further assignment required
    event :review do
      transitions from: [:assigned, :completed], to: :review
    end
    # allow reopening of closed jobs without requiring new job created
    event :reopen do
      transitions from: [:completed], to: :unassigned
    end
    
  end
  
  def status=(status)
    if(status == Job::STATE_UNASSIGNED.to_s) then reopen!
    elsif(status == Job::STATE_COMPLETED.to_s) then complete!
    elsif(status == Job::STATE_REVIEW.to_s) then review!
    end
  end

  def broadcast
    ActionCable.server.broadcast(
      'jobs',
      job: self
    )
  end

end
