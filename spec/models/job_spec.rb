require 'rails_helper'

RSpec.describe Job, type: :model do

  # Validation tests
  it { should validate_presence_of(:job_number) }
  it { should validate_presence_of(:reported_date) }

  describe 'Contractor association' do

    let(:assignment) { create(:assignment) }

    it 'makes currently assigned contractor accessible' do
      expect(assignment.job.latest_assignment.contractor).to eq(assignment.job.contractor)
    end
    
  end
    
end
