class Api::V1::JobsController < SecureAPIController

  before_action :set_job, only: [:show, :update, :destroy, :release]

  # GET /jobs
  def index
    render json: Job.all.to_json(include: [:assignments, :items])
  end

  # GET /jobs/:id
  def show
    render json: @job.to_json(include: [:assignments, :items])
  end

  # PUT /jobs/:id
  def update
    if can_edit(@current_user, @job) then
      @job.update(job_params)
      head :ok
    else
      head :forbidden
    end
  end
  
  private

  def job_params
    # following params can be edited by clients
    params.permit(:short_title, :description, :notes, :completed, :signature)
  end

  def set_job
    @job = Job.find(params[:id])
  end

  def can_edit(user, job)
    user &&
      job.latest_assignment.contractor.id == user.id
  end

end
