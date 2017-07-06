module Api
  module V1
    class AssignmentsController < SecureAPIController
      before_action :set_paper_trail_whodunnit
      before_action :set_assignment, only: [:show, :update, :destroy]

      # GET /assignments
      def index
        if @current_user then
          if params[:active] then
            render json: @current_user.assignments.accepted.to_json({include: :job})
          else
            render json: @current_user.assignments.to_json({include: :job})
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
