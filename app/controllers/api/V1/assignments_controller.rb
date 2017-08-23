module Api
  module V1
    class AssignmentsController < SecureAPIController
      before_action :set_paper_trail_whodunnit
      before_action :set_assignment, only: [:show, :update, :destroy]

      # GET /assignments
      api! 'Get a list of assignments for user'
      header "Authorization: Bearer", "<JWT_TOKEN>"

      @@json_template = { include: { job: { include: :tenant } } }

      def index
        if @current_user then
          if params[:active] then
            render json: @current_user.assignments.latest.with_open_job.active.to_json(@@json_template)
          else
            render json: @current_user.assignments.to_json(@@json_template)
          end
        else
          fail NotAuthenticatedError
        end
      end

      # GET /assignments/:id
      api! 'Get details of a particular assignment'
      header "Authorization: Bearer", "<JWT_TOKEN>"
      def show
        if @current_user then
          render json: @assignment.to_json(@@json_template)
        else
          fail NotAuthenticatedError
        end
        
      end

      # PUT /assignments/:id
      api! 'Update a particular assignment'
      header "Authorization: Bearer", "<JWT_TOKEN>"
      param :assignment, Hash, desc: 'Assignment properties' do
        param :contractor_id, String, desc: "ID of Contractor (User) associated with this assignment", required: false
        param :job_id, String, desc: "ID of Job associated with this assignment", required: false
        param :am_pm_visit, ["am", "pm"], desc: "Whether assignment is AM or PM visit.", required: false
        param :resolution, String, desc: "Resolution", required: false
        param :notes, String, desc: "Supplementary notes", required: false
        param :scheduled_date, String, desc: "Date assignment scheduled to be done", required: false
        param :actual_date, String, desc: "Date assignment was actually fulfilled. NOTE: not set automatically on state change to fulfilled, but it should be", required: false
        param :status, ["accepted, rejected, fulfilled"], desc: "Status of the assignment", required: false
        param :signature, String, desc: "Encoded image data - signature image upload", required: false
      end
      def update
        if @current_user then
          if can_edit? then
            @assignment.update!(assignment_params)
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
        params.permit(:contractor_id, :job_id, :am_pm_visit, :resolution, :notes, :scheduled_date, :actual_date, :status)
      end

      def set_assignment
        @assignment = Assignment.find(params[:id])
      end

      def can_edit?
        @current_user.is_admin || @assignment.contractor.id == @current_user.id
      end

    end
  end
end
