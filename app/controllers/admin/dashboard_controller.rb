class Admin::DashboardController < SecureAdminController
  include ActionView::Layouts
  layout "application"

  before_action :authenticate_user
  
  def index
    @jobs = Job.all
    @open_job_count = Job.open.length
  end

end
