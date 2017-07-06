require 'rails_helper'

RSpec.describe Assignment, type: :model do

  let(:assignment) { create(:assignment) }
  
  it { should belong_to(:user) }
  it { should belong_to(:job) }

  describe 'Status AASM validator' do
    it 'prevents invalid status being saved' do
      assignment.status = "test"
      expect(assignment.status).not_to eq("test")
    end
  end

  describe 'Creating an assignment' do
    it 'sets the previous assignment to be cancelled' do
      expect(assignment.status).to eq("pending")
      create(:assignment, job: assignment.job)
      assignment.reload
      expect(assignment.status).to eq("cancelled")
    end

    it 'sets the new assignment to be the latest assignment of the job' do
      expect(assignment.job.latest_assignment.id).to eq(assignment.id)
      new_assignment = create(:assignment, job: assignment.job)
      expect(assignment.job.latest_assignment.id).to eq(new_assignment.id)
    end
  end
end
