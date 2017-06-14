require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  # initialize test data 
  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }
  
  # Test suite for GET /api/v1/user unauthenticated
  describe 'GET /api/v1/user' do
    # make HTTP get request before each example
    before { get '/api/v1/user' }

    it 'returns responds 401 to unauthenticated requests' do
      expect(response).to have_http_status(401)
    end
  end

  # Tests for GET /api/v1/user authenticated
  describe 'GET /api/v1/user' do
    # make HTTP get request before each example
    let(:user) { create(:user) }
    before { get '/api/v1/user', headers: authenticated_header(user.id, false) }

    it 'returns responds 200 to authenticated requests' do
      expect(response).to have_http_status(200)
    end
  end

  
end
