class Admin::AttachmentsController < SecureAdminController

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
  end
  
end
