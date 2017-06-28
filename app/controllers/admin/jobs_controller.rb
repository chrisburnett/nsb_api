class Admin::JobsController < SecureAdminController

  include ActionView::Layouts
  layout "application"

  before_action :authenticate_user
  
  def index
    respond_to do |format|
      format.html
      format.json { render json: JobDatatable.new(view_context) }
    end
  end

  def new
    @job = Job.new
  end

end
