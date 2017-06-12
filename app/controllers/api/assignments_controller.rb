class Api::AssignmentsController < ApplicationController

  before_action :set_assignment, only: [:show, :update, :destroy]

  # GET /assignments
  def index
    @assignments = Assignment.all
    render json: @assignments.to_json
  end

  # POST /assignments
  def create
    @assignment = Assignment.create!(assignment_params)
    json_response(@assignment, :created)
  end

  # GET /assignments/:id
  def show
    render json: @assignment.to_json
  end

  # PUT /assignments/:id
  def update
    @assignment.update(assignment_params)
    head :no_content
  end

  # DELETE /assignments/:id
  def destroy
    @assignment.destroy
    head :no_content
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
