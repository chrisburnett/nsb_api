require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  def authenticated_header(user_id, admin)
    token = Authentication::AuthToken.encode({ user_id: user_id, admin: admin })
    { 'Authorization': "Bearer #{token}" }
  end

  # initialize test data 
  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }
  
  # Test suite for GET /api/user unauthenticated
  describe 'GET /api/user' do
    # make HTTP get request before each example
    before { get '/api/user' }

    it 'returns responds 401 to unauthenticated requests' do
      expect(response).to have_http_status(401)
    end
  end

  # Tests for GET /api/user authenticated
  describe 'GET /api/user' do
    # make HTTP get request before each example
    let(:user) { create(:user) }
    before { get '/api/user', headers: authenticated_header(user.id, false) }

    it 'returns responds 200 to authenticated requests' do
      expect(response).to have_http_status(200)
    end
  end

  
end
