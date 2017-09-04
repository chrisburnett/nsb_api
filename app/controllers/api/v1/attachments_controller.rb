class Api::V1::AttachmentsController < SecureAPIController
  before_action :set_assignment, only: [:create, :destroy]

  def create
    if @current_user then
      if can_create_attachment? then
        @attachment = Attachment.new(safe_params)
        if(@attachment.save)
        then head :created
        else head :unprocessable_entity
        end
      else
        head :forbidden
      end
    else
      fail NotAuthenticatedError
    end
  end

  def show
    if @current_user then
      file = Attachment.find(params[:id])
      send_file "public#{file.attachment}"
    end
  end

  private

  def set_assignment
    @assignment = Assignment.find(params[:assignment_id])
  end
  
  def can_create_attachment?
    @assignment.contractor_id == @current_user.id || @assignment.user_id == @current_user.id
  end

  def safe_params
    params.permit(:assignment_id, :attachment)
  end
  
end

