class Admin::TenantsController < SecureAdminController

  before_action :authenticate_user
  
  def index
    # if a search term is provided, then return matching id/tenant
    # pairs for autocomplete fields
    if params[:term] then
      render json: Tenant.where("name ILIKE ?", "%#{params[:term]}%").map { |t| {id: t.id, value: t.name} }
    else
      render json: Tenant.all.to_json
    end
  end
  
end
