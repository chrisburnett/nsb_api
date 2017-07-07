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
    Job.find(params[:id]).update(safe_params)
  end

  def delete
    @job = Job.find(params[:id])
    @job.destroy
  end

  private

  def safe_params
    params.require(:job).permit(:short_title,
                                :reported_fault,
                                :notes,
                                :priority_id,
                                :tenant_id,
                                :client_id,
                                :status,
                                items_attributes: [:sor_code, :description, :quantity])
  end
  
end
