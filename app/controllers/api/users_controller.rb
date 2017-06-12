class Api::UsersController < SecureAPIController

  def index
    @users = User.all
    render json: @users.to_json
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end
  
end
