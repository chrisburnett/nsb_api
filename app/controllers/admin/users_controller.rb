class Admin::UsersController < SecureAdminController
  include ActionView::Layouts
  layout "application"
  
  before_action :authenticate_user
  
  def index
    # if a search term is provided, then return matching id/tenant
    # pairs for autocomplete fields
    respond_to do |format| 

      format.json do
        if params[:term] then
          render json: search(params[:term])
        else
          render json: User.all.to_json
        end
      end
      
      format.html do
        @admin = params[:admin]
        if @admin then
          if @admin == "true" then
            @subject = "Administrator"
            @users = User.where(is_admin: true)
          else
            @subject = "Contractor"
            @users = User.where(is_admin: false)
          end
        else
          @subject = "User"
          @users = User.all
        end
      end
    end
  end

  def new
    @subject = params[:admin] == "true" ? "Administrator" : "Contractor"
    @admin = params[:admin]
    @user = User.new(is_admin: params[:admin])
  end

  def create
    @user = User.new(safe_params)
    if @user.save
      flash[:success] = "User #{@user.username} was created."
      redirect_to admin_users_path(admin: @user.is_admin)
    else
      render :new
    end
    
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id]).destroy()
  end

  private

  def safe_params
    params.require(:user).permit(:username, :name, :is_admin, :password, :password_confirmation)
  end

  def search(term)
    User.where("name ILIKE ?", "%#{params[:term]}%").map { |c| {id: c.id, value: "#{c.name}" } }
  end
  
end
