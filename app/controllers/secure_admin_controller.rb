class SecureAdminController < ActionController::Base

  helper_method :current_user, :logged_in?
  
  def authenticate_user
    if !logged_in? then
      redirect_to admin_login_url
    end
  end
  
  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def logged_in?
    current_user != nil
  end
  
end

