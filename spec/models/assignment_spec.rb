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
  
end
