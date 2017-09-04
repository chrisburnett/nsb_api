require 'rails_helper'

RSpec.describe 'Attachments API', type: :request do

  let(:user) { create(:user) }
  let(:contractor) { create(:user) }

  let(:assignment) { create(:assignment, user: user, contractor: contractor) }
  let!(:header) { authenticated_header(user.id, false) }
  
  describe 'POST /api/v1/assignments/#/attachment' do
    it 'allows attachment to be uploaded to the assignment' do
      post "/api/v1/assignments/#{assignment.id}/attachment", headers: header
      
    end
  end
  
end
