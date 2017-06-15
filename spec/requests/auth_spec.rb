require 'rails_helper'

RSpec.describe 'Auth API', type: :request do

  # initialize test data 
  let!(:user) { create(:user) }

  describe 'POST /api/v1/auth' do
    it 'returns responds 200 to successful authentication requests' do
      post '/api/v1/auth', headers: { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(user.username, user.password) }
      expect(response).to have_http_status(200)
    end
    
    it 'returns responds 401 to unsuccessful authentication requests' do
      post '/api/v1/auth', headers: { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(user.username, "wrongpass") }
      expect(response).to have_http_status(401)
    end
  end

  
end
