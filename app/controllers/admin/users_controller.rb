class Admin::UsersController < SecureAdminController

  before_action :authenticate_user
  
  def index
    # if a search term is provided, then return matching id/tenant
    # pairs for autocomplete fields
    if params[:term] then
      render json: User.where("name ILIKE ?", "%#{params[:term]}%").map { |c| {id: c.id, value: "#{c.name}" } }
    else
      render json: User.all.to_json
    end
  end
  
end
