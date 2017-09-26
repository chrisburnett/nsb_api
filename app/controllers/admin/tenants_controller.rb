class Admin::TenantsController < SecureAdminController

  include ActionView::Layouts
  layout "application"
  
  before_action :authenticate_user
  
  def index
    @tenants = Tenant.all
    respond_to do |format|    
      # if a search term is provided, then return matching id/tenant
      # pairs for autocomplete fields
      format.json do
        if params[:term] then
          render json: search(params[:term])
        else
          render json: TenantDatatable.new(view_context)
        end
      end
      format.html
    end
  end

  def new
    @tenant = Tenant.new()
  end

  def create
    @tenant = Tenant.new(safe_params)
    if @tenant.save
      flash[:success] = "Tenant #{@tenant.id} was created."
      redirect_to admin_tenants_path()
    else
      render :new
    end
    
  end
  
  def edit
    @tenant = Tenant.find(params[:id])
  end

  def update
    @tenant = Tenant.find(params[:id])
    if @tenant.update(safe_params) then
      flash[:success] = "Tenant #{params[:id]} was updated."
      redirect_to admin_tenants_path()
    else
      render :edit
    end
  end

  def destroy
    @tenant = Tenant.find(params[:id])
    @tenant.destroy
  end
  
  private

  def search(term)
    Tenant.where("name || ' ' || address ILIKE ?", "%#{params[:term]}%").map { |t| t.attributes.merge({value: "#{t.name}, #{t.address}" }) }
  end

  def safe_params
    params.require(:tenant).permit(:id, :name, :address, :notes, :contact_number_1, :contact_number_2, :contact_number_3)
  end
  
end
