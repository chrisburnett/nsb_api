require 'rails_helper'

RSpec.describe Assignment, type: :model do

  let(:assignment) { create(:assignment) }
  
  it { should belong_to(:user) }
  it { should belong_to(:job) }

  describe 'Status validator' do
    it 'prevents invalid status being saved' do
      assignment.status = "test"
      expect(assignment.save).to be_falsey
    end
  end

  describe 'Latest assignment' do
    it 'sets itself to be the latest assignment of the job on create' do
      expect(assignment.job.latest_assignment.id).to eq(assignment.id)
      new_assignment = create(:assignment, job: assignment.job)
      expect(assignment.job.latest_assignment.id).to eq(new_assignment.id)
    end
  end
  
end
