class Admin::JobsController < SecureAdminController

  include ActionView::Layouts
  layout "application"
  
  before_action :authenticate_user

  def index
    respond_to do |format|
      format.html
      format.json { render json: JobDatatable.new(view_context, params) }
    end
  end

  def new
    @job = Job.new
    @job.tenant = Tenant.new
    @job.client = Client.new
  end

  def edit
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(safe_params.except(:client_attributes, :tenant_attributes).merge({ user_id: session[:user_id] }))
    @job.tenant = Tenant.find_or_create_by(safe_params[:tenant_attributes].transform_values { |v| if v == "" then nil else v end })
    @job.client = Client.find_or_create_by(safe_params[:client_attributes])
    if @job.save
      flash[:success] = "Job #{@job.id} was created."
      redirect_to admin_dashboard_path
    else
      render :new
    end
    
  end

  def update
    @job = Job.find(params[:id])
    @job.update(safe_params.except(:client_attributes, :tenant_attributes))
    @job.tenant = Tenant.find_or_create_by(safe_params[:tenant_attributes])
    @job.client = Client.find_or_create_by(safe_params[:client_attributes])
    @job.save!

    if @job.errors.empty?
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
    params.require(:job).permit(:job_number,
                                :invoice_number,
                                :reported_fault,
                                :reported_date,
                                :due_date,
                                :notes,
                                :priority_id,
                                :status,
                                :id,
                                client_attributes: [:id, :name, :address, :notes],
                                tenant_attributes: [:id, :name, :address, :contact_number_1, :contact_number_2, :contact_number_3, :notes],
                                items_attributes: [:id, :sor_code, :description, :quantity, :_destroy])
  end
  
end
