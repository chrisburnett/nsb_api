class Api::V1::AssignmentsController < SecureAPIController

  before_action :set_assignment, only: [:show, :update, :destroy]

  # GET /assignments
  def index
    if @current_user then
      @assignments = Assignment.where(user_id: @current_user.id)
      render json: @assignments.to_json(include: :job)
    else
      fail NotAuthenticatedError
    end
  end

  # POST /assignments
  def create
    if @current_user then
      # can create assignment if job is available
      job = Job.find_by(id: params[:job_id])
      if job and !job.assigned then
        @assignment = Assignment.create!(assignment_params)
        job.assigned = true
        job.save
        json_response(@assignment, :created)
      else
        head :unprocessable_entity # unprocessable entity
      end
    else
      fail NotAuthenticatedError
    end
  end

  # GET /assignments/:id
  def show
    if @current_user then
      render json: @assignment.to_json(include: :job)
    else
      fail NotAuthenticatedError
    end
  end

  # PUT /assignments/:id
  def update
    if @current_user then
      if @assignment.user.id == @current_user.id then
        @assignment.update(assignment_params)
        head :no_content
      else
        head :forbidden # not allowed to edit other people's assignments
      end
    else
      fail NotAuthenticatedError
    end
  end

  private

  def assignment_params
    # whitelist params
    params.permit(:job_id, :user_id, :assignment_date, :am_pm_visit, :resolution, :notes, :scheduled_date, :actual_date)
  end

  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

end
