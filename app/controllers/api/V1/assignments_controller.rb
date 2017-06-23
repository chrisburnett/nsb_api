module Api
  module V1
    class AssignmentsController < SecureAPIController
      before_action :set_paper_trail_whodunnit
      before_action :set_assignment, only: [:show, :update, :destroy]

      # GET /assignments
      def index
        if @current_user then
          # get assignments where this user is the contractor
          @assignments = Assignment.where(contractor_id: @current_user.id)
          if params[:active] then
            render json: @assignments.active.to_json({include: :job, methods: :active})
          else
            render json: @assignments.to_json({include: :job, methods: :active})
          end
        else
          fail NotAuthenticatedError
        end
      end

      # DISABLING - contractors don't create assignments
      # will be done via the admin interface
      # POST /assignments
      # def create
      #   if @current_user then
      #     job = Job.find_by(id: params[:job_id])
      #     if job then
      #       @assignment = Assignment.new(assignment_params)
      #       @assignment.user = @current_user
      #       @assignment.save
      #       job.update_attribute(:assigned, true) # probably bad practice
      #       json_response(@assignment, :created)
      #     else
      #       head :unprocessable_entity # unprocessable entity
      #     end
      #   else
      #     fail NotAuthenticatedError
      #   end
      # end

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
            if @assignment.update(assignment_params)
              head :no_content
            else
              head :unprocessable_entity
            end
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
