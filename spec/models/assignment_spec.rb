require 'rails_helper'

RSpec.describe Assignment, type: :model do

  let!(:assignment) { create(:assignment) }
  
  it { should belong_to(:user) }
  it { should belong_to(:job) }

  describe 'Status AASM validator' do
    it 'prevents invalid status being saved' do
      expect { assignment.status = "test" }.to raise_error(ActiveRecord::RecordInvalid)
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

  describe 'latest scope' do
    it 'returns the latest assignments' do
      expect(Assignment.latest.first.id).to eq(assignment.id)
    end
  end
end
