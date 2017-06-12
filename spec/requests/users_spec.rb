require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  def authenticated_header(user_id, admin)
    token = Authentication::AuthToken.encode({ user_id: user_id, admin: admin })
    { 'Authorization': "Bearer #{token}" }
  end

  # initialize test data 
  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }

  # LOGGED IN ADMIN USERS ONLY should be allowed to retrieve full user list
  
  # Test suite for GET /api/users unauthenticated
  describe 'GET /api/users' do
    # make HTTP get request before each example
    before { get '/api/users' }

    it 'returns responds 401 to unauthenticated requests' do
      expect(response).to have_http_status(401)
    end
  end

  # Tests for GET /api/users authenticated
  describe 'GET /api/users' do
    # make HTTP get request before each example
    let(:user) { create(:user) }
    before { get '/api/users', headers: authenticated_header(user.id, false) }

    it 'returns responds 200 to authenticated requests' do
      expect(response).to have_http_status(200)
    end
  end

  
end
