class Api::UsersController < SecureAPIController

  def show
    if @current_user then
      render json: @current_user, status: :ok
    else
      fail NotAuthenticatedError
    end
  end

  # def update
  # end

  # def destroy
  # end
  
end
