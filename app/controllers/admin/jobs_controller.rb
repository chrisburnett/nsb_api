class Admin::JobsController < SecureAdminController

  include ActionView::Layouts
  layout "application"

  before_action :authenticate_user
  
  def index
    respond_to do |format|
      format.html
      format.json { render json: JobDatatable.new(view_context) }
    end
  end

  def new
    @job = Job.new
  end

  def edit
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(safe_params.merge({ user_id: session[:user_id] }))
    if @job.save
      flash[:success] = "Job #{@job.id} was created."
      redirect_to admin_dashboard_path
    else
      render :new
    end
    
  end

  def update
    if Job.find(params[:id]).update(safe_params) then
      flash[:success] = "Job #{params[:id]} was updated."
      redirect_to admin_dashboard_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
  end

  private

  def safe_params
    params.require(:job).permit(:short_title,
                                :reported_fault,
                                :reported_date,
                                :notes,
                                :priority_id,
                                :tenant_id,
                                :client_id,
                                :status,
                                items_attributes: [:id, :sor_code, :description, :quantity, :_destroy])
  end
  
end
