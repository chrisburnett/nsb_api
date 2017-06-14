class Api::V1::UsersController < SecureAPIController

  def show
    if @current_user then
      render json: @current_user, status: :ok
    else
      fail NotAuthenticatedError
    end
  end

  def update
    if @current_user then
      @current_user.update(safe_params)
    else
      fail NotAuthenticatedError
    end
  end

  # def destroy
  # end

  private

  def safe_params
    params.permit(:name,:address,:password)
  end
  
end
