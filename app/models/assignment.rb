class Assignment < ApplicationRecord
  include AASM

  has_paper_trail # versioning/auditing

  belongs_to :user
  belongs_to :job
  belongs_to :contractor, class_name: "User"

  validates_presence_of :job_id

  before_create :set_assignment_date
  after_create :update_job_latest_assignment
  
  # allow signatures to be uploaded
  mount_uploader :signature, SignatureUploader 

  # state machine
  aasm column: 'status' do

    after_all_events :update_job_state
    
    state :pending, initial: true
    state :accepted, :rejected, :cancelled, :fulfilled

    event :accept do
      transitions from: :pending, to: :accepted
    end
    event :reject do
      transitions from: [:pending, :accepted], to: :rejected
    end
    event :cancel do
      transitions from: [:pending, :accepted], to: :cancelled
    end
    event :fulfil do
      transitions from: :accepted, to: :fulfilled
    end
    
  end

  # on state transition
  def update_job_state
    if job.latest_assignment&.id == id then
      #if accepted? then job.assign!
      if (rejected? || cancelled?) && job.may_unassign? then job.unassign!
      elsif fulfilled? then job.review!
      end
    end
  end
  
  def active
    id == job.latest_assignment&.id && accepted? && !job.completed?
  end

  def status=(status)
    # validation hack - declarative validations don't seem to play with aasm
    raise ActiveRecord::RecordInvalid unless
      %w(pending accepted rejected cancelled fulfilled).include?(status)
    
    if(status == Assignment::STATE_ACCEPTED.to_s) then accept!
    elsif(status == Assignment::STATE_REJECTED.to_s) then reject!
    elsif(status == Assignment::STATE_CANCELLED.to_s) then cancel!
    elsif(status == Assignment::STATE_FULFILLED.to_s) then fulfil!
    end
  end
  
  private

  # after create
  def update_job_latest_assignment
    # if there's a currently active assignment, cancel it
    if job.latest_assignment&.pending? || job.latest_assignment&.accepted? then
      job.latest_assignment.cancel!
    end
    job.update(latest_assignment_id: self.id)
    if job.may_assign? then job.assign! end
  end
  
  def set_assignment_date
    self.assignment_date = Time.now
  end
  
  def set_response_date
    self.response_date = Time.now
  end

  # before updating status if this is the current assignment and it's
  # being fulfilled, unlink it (leaving the job unassigned)
  # def unlink_job_if_necessary
  #   if fulfilled? &&
  #      self.job.latest_assignment.id == self.id then
  #     self.job.update(latest_assignment: nil)
  #   end
  # end

end
