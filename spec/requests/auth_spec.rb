require 'rails_helper'

RSpec.describe 'Auth API', type: :request do

  # initialize test data 
  let!(:user) { create(:user) }

  describe 'POST /auth' do
    # make HTTP get request before each example
    before { post '/auth', params: { username: user.username, password: user.password } }

    it 'returns responds 200 to successful authentication requests' do
      post '/auth', params: { username: user.username, password: user.password }
      expect(response).to have_http_status(200)
    end
    
    it 'returns responds 401 to unsuccessful authentication requests' do
      post '/auth', params: { username: user.username, password: "floomshahkjd" }
      expect(response).to have_http_status(401)
    end
  end

  
end
