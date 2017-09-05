class Api::V1::UsersController < SecureAPIController

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :GET, '/user', 'Show an user'
  error code: 401
  def show
    if @current_user then
      render json: @current_user, except: :password_digest, status: :ok
    else
      fail NotAuthenticatedError
    end
  end

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :PUT, '/user', 'Update an user'
  def update
    if @current_user then
      @current_user.update(safe_params)
      render json: @current_user, except: :password_digest, status: :ok
    else
      fail NotAuthenticatedError
    end
  end

  # def destroy
  # end

  private

  def safe_params
    params.permit(:name,:address,:password,:registration_id)
  end
  
end
