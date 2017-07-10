class Admin::TenantsController < SecureAdminController

  before_action :authenticate_user
  
  def index
    respond_to do |format|    
      # if a search term is provided, then return matching id/tenant
      # pairs for autocomplete fields
      format.json do
        if params[:term] then
          render json: search(params[:term])
        else
          render json: Tenant.all.to_json
        end
      end
      format.html
    end
  end

  private

  def search(term)
    Tenant.where("name || ' ' || address ILIKE ?", "%#{params[:term]}%").map { |t| {id: t.id, value: "#{t.name}, #{t.address}" } }
  end
  
end
