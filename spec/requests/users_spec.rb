require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  # initialize test data 
  let!(:users) { create_list(:user, 10) }
  let!(:user_id) { users.first.id }
  
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

    it 'does not return the password digest' do
      expect(json['password_digest']).to be_nil
    end
  end

  describe 'GET /api/v1/user' do
    let(:disabled_user) { create(:user) }
    
    context 'when the user is inactive' do
      it 'responds 401' do
        disabled_user.update(active: false)
        get '/api/v1/user', headers: authenticated_header(disabled_user.id, false)
        expect(response).to have_http_status(401)
      end
    end
  end
  
  describe 'PUT /api/v1/user' do
    let(:valid_attributes) { { name: "Bob", registration_id: "11111111111" } }
    
    context 'when the record exists' do
      before { put "/api/v1/user/", params: valid_attributes, headers: authenticated_header(user_id, false) }

      it 'updates the record' do
        expect(response.body).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates the registration ID' do
        users.first.reload
        expect(users.first.registration_id).to eq("11111111111")
        expect(users.first.name).to eq("Bob")
      end
    end
  end
  
end
