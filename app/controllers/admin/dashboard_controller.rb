class Admin::DashboardController < SecureAdminController
  layout "application"
  before_action :authenticate_user
  
  def index
    @jobs = Job.all
  end

end
