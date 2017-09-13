require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_presence_of(:name) }

  describe 'before create' do
    it 'sets active flag to be true' do
      user = create(:user)
      expect(user.active).to be_truthy
    end
  end
end
