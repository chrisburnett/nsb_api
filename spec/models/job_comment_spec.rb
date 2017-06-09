require 'rails_helper'

RSpec.describe JobComment, type: :model do

  it { should belong_to(:user) }
  it { should belong_to(:job) }
  
end
