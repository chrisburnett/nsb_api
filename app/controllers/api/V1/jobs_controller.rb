class Api::V1::JobsController < ApplicationController

  before_action :set_job, only: [:show, :update, :destroy]

  # GET /jobs
  def index
    if params[:available] == 'true' then
      render json: Job.available.to_json(include: :assignments)
    else
      render json: Job.all.to_json
    end
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
    params.permit(:job_id, :user_id, :tenant_id, :short_title, :reported_date, :completed_date, :sor_code, :description, :notes, :assigned, :available, :completed)
  end

  def set_job
    @job = Job.find(params[:id])
  end

end
