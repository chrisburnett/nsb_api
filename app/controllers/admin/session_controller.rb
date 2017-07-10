class Admin::SessionController < ActionController::Base

  include ActionView::Layouts
  layout "application"
  
  def index
    @hide_sidebar = true
  end

  def create
    user = User.find_by(username: params[:username]).try(:authenticate, params[:password])
    if user && user.is_admin then
      session[:user_id] = user.id
      redirect_to admin_dashboard_url
    else
      flash[:notice] = "Invalid username or password"
      render :index
    end
  end


  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to admin_login_url
  end
  
end
