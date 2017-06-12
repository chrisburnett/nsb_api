class Api::JobsController < ApplicationController

  before_action :set_job, only: [:show, :update, :destroy]

  # GET /jobs
  def index
    @jobs = Job.all
    render json: @jobs.to_json(include: :assignments)
  end

  # GET /jobs/:id
  def show
    render json: @job.to_json(include: :assignments)
  end

  # PUT /jobs/:id
  def update
    @job.update(job_params)
    head :no_content
  end

  private

  def job_params
    # whitelist params
    params.permit(:job_id, :user_id, :tenant_id, :short_title, :reported_date, :completed_date, :sor_code, :description, :notes)
  end

  def set_job
    @job = Job.find(params[:id])
  end

end
