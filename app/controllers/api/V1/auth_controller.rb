class Api::V1::AuthController < ApplicationController

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :GET, '/auth'
  error code: 401
  def authenticate
    authenticate_or_request_with_http_basic do |username, password| 
      user = User.find_by_username(username).try(:authenticate, password)
      if user
        render json: { auth_token: user.generate_auth_token, username: user.username, fullname: user.name }, status: :ok
      else
        render json: { error: 'Invalid username or password' }, status: :unauthorized
      end
    end
  end

end
