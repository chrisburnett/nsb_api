class Admin::DashboardController < SecureAdminController
  include ActionView::Layouts
  layout "application"

  before_action :authenticate_user
  
  def index
    @jobs = Job.all
    @open_job_count = Job.where.not(status: Job::STATE_COMPLETED.to_s).length
  end

end
