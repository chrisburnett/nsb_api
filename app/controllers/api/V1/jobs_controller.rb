class Api::V1::JobsController < SecureAPIController

  before_action :set_job, only: [:show, :update, :destroy, :release]

  # GET /jobs
  api! 'Get a list of all jobs'
  def index
    render json: Job.all.to_json(include: [:assignments, :items], methods: :status)
  end

  # GET /jobs/:id
  api! 'Get detail for a given job'
  param :id, Integer, desc: "Job ID number to retrieve"
  def show
    render json: @job.to_json(include: [:assignments, :items])
  end

  # PUT /jobs/:id
  api! 'Update a job'
  desc 'Note: only administrators, and users to whom a job is assigned, may edit a job.'
  param :job, Hash, desc: 'Job properties' do
    param :job_number, String, required: false
    param :description, String, required: false
    param :notes, String, required: false
  end
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
    params.permit(:job_number, :description, :notes, :status, :signature)
  end

  def set_job
    @job = Job.find(params[:id])
  end

  def can_edit(user, job)
    user &&
      (user.is_admin || job.latest_assignment.contractor.id == user.id)
  end

end
