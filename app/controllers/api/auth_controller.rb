class Api::AuthController < ApplicationController

    def authenticate
      user = User.find_by_username(params[:username]).try(:authenticate, params[:password])
      if user
        render json: { auth_token: user.generate_auth_token }, status: :ok
      else
        render json: { error: 'Invalid username or password' }, status: :unauthorized
      end
    end

    def index

    end


end
