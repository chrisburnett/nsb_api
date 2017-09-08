class Tenant < ApplicationRecord

  has_many :jobs, inverse_of: :tenant
  has_many :assignments, through: :jobs
  
  validates_presence_of :name
  validates_presence_of :address

  before_save :notify_assignments

  private

  # all jobs/assignments need to notify their contractors on tenant
  # changes
  def notify_assignments
    changes = self.changes.except(:created_at, :updated_at)
    assignments.active.latest.each do |assignment|
      registration_id = assignment.contractor.registration_id
      title = 'Assignment changed'
      message = ''
      changes.each do |k,v|
        message << "Tenant #{k} changed to: #{v[1]}"
      end
      data = self.as_json
      FCMNotifier.push(title, message, registration_id, data)
    end
  end

end
