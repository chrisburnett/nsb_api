class Admin::JobsController < SecureAdminController

  
  
  def index
    respond_to do |format|
      format.html
      format.json { render json: JobDatatable.new(view_context) }
    end
  end

end
