require 'rails_helper'

RSpec.describe Assignment, type: :model do

  it { should belong_to(:user) }
  it { should belong_to(:job) }

  # validation
  it { should validate_presence_of(:assignment_date) }
  
end
