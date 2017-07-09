class Admin::AssignmentsController < SecureAdminController

  include ActionView::Layouts
  layout "application"

  before_action :authenticate_user
  
  def new
    # assignment controller only accessable via valid job resource
    # route
    @assignment = Assignment.new(job_id: params[:job_id])
  end
  def edit
    # assignment controller only accessable via valid job resource
    # route
    @assignment = Assignment.find(params[:id])
  end

  def create
    @assignment = Assignment.new(safe_params.merge({ user_id: session[:user_id],
                                                     job_id: params[:job_id] }))
    if @assignment.save
      flash[:success] = "Assignment #{@assignment.id} was created."
      redirect_to admin_dashboard_path
    else
      render :new
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update(safe_params) then
      flash[:success] = "Assignment #{@assignment.id} was updated."
      redirect_to admin_dashboard_path
    else
      render :edit
    end
  end
  
  private

  def safe_params
    params.require(:assignment).permit(:contractor_id,
                                       :scheduled_date,
                                       :actual_date,
                                       :am_pm_visit,
                                       :job_id,
                                       :user_id,
                                       :notes,
                                       :status)
  end
  
end
