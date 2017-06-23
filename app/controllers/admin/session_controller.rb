class Admin::SessionController < ApplicationController
  
  # show the login page
  def index
    
  end

  # just use old fashioned non-JWT authentication for the web app
  # otherwise we need to do a lot of work to pass the token back every time
  def create
    user = User.find_by_username(params[:username]).try(:authenticate, params[:password])
    if user && user.admin? then
      session[:user_id] = user.id
      redirect_to admin_dashboard_url
    else
      flash[:notice] = "Invalid username or password"
      flash[:color] = "invalid"
      render :index
    end
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to admin_login_url
  end

end
