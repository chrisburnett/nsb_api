require 'rails_helper'

RSpec.describe Job, type: :model do

    # Validation tests
    it { should validate_presence_of(:short_title) }
    it { should validate_presence_of(:reported_date) }
end
