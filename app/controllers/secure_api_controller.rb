class NotAuthenticatedError < StandardError
end
class AuthenticationTimeoutError < StandardError
end

class SecureAPIController < ActionController::Base
  include Authentication
  include Response
  include ExceptionHandler
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :set_current_user, :authenticate_request, :set_paper_trail_whodunnit
  
  skip_before_action :verify_authenticity_token
  
  rescue_from NotAuthenticatedError do
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end
  
  rescue_from JWT::ExpiredSignature do
    render json: { error: 'Auth token is expired' }, status: 419 # unofficial timeout status code
  end

   # Based on the user_id inside the token payload, find the user.
  def set_current_user
    if decoded_auth_token
      begin
        @current_user ||= User.where(active: true).find(decoded_auth_token[:user_id])
      rescue
        raise NotAuthenticatedError
      end
    end
  end

  # Check to make sure the current user was set
  def authenticate_request
    if auth_token_expired?
      fail AuthenticationTimeoutError
    elsif !@current_user
      fail NotAuthenticatedError
    end
  end

  protected

  def auth_token_expired?
    decoded_auth_token && decoded_auth_token.expired?
  end
  # return the cached decoded token, or decode if needed
  def decoded_auth_token
    @decoded_auth_token ||= Authentication::AuthToken.decode(http_auth_header_content)
  end

  # JWT's are stored in the Authorization header using this format:
  # Bearer somerandomstring.encoded-payload.anotherrandomstring
  def http_auth_header_content
    return @http_auth_header_content if defined? @http_auth_header_content
    @http_auth_header_content = begin
      if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      else
        nil
      end
    end
  end

  def user_for_paper_trail
    @current_user.id
  end  
end



