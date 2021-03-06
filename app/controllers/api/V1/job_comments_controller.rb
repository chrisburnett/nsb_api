class Api::V1::JobCommentsController < SecureAPIController

  before_action :set_comment, only: [:show, :update, :destroy]

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :GET, '/jobs/:job_id/comments', 'List job comments'
  def index
    if @current_user then
      job = Job.find_by(id: params[:job_id])
      if job then
        render json: job.job_comments.to_json
      else
        head :unprocessable_entity
      end
    else
      fail NotAuthenticatedError
    end
  end
  
  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :POST, '/jobs/:job_id/comments', 'Create a job comment'
  def create
    if @current_user then
      job = Job.find_by(id: params[:job_id])
      if job then
        comment = JobComment.create!(comment_params)
        json_response(comment, :created)
      else
        head :unprocessable_entity
      end
    else
      fail NotAuthenticatedError
    end
  end

  # GET /assignments/:id
  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :GET, '/jobs/:job_id/comments/:id', 'Show a job comment'
  error code: 404
  def show
    if @current_user then
      render json: @comment.to_json
    else
      fail NotAuthenticatedError
    end
  end

  def update
    if @current_user then
      if @comment.user.id == @current_user.id then
        @comment.update(comment_params)
        head :no_content
      else
        head :forbidden # not allowed to edit other people's comments
      end
    else
      fail NotAuthenticatedError
    end
  end

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :DELETE, '/jobs/:job_id/comments/:id', 'Destroy a job comment'
  error code: 403
  def destroy
    if @current_user then
      if @comment && @comment.user.id == @current_user.id then
        @comment.destroy
      else
        head :forbidden
      end
    else
      fail NotAuthenticatedError
    end
  end
  
  private

  def comment_params
    params.permit(:job_id, :user_id, :comment_text)
  end

  def set_comment
    @comment = JobComment.find(params[:id])
  end
end
