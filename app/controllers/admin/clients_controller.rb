class Admin::ClientsController < SecureAdminController

  include ActionView::Layouts
  layout "application"
  
  before_action :authenticate_user
  
  def index
    @clients = Client.all
    respond_to do |format|    
      # if a search term is provided, then return matching id/client
      # pairs for autocomplete fields
      format.json do
        if params[:term] then
          render json: search(params[:term])
        else
          render json: ClientDatatable.new(view_context)
        end
      end
      format.html
    end
  end

  def new
    @client = Client.new()
  end

  def create
    @client = Client.new(safe_params)
    if @client.save
      flash[:success] = "Client #{@client.id} was created."
      redirect_to admin_clients_path()
    else
      render :new
    end
    
  end
  
  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(safe_params) then
      flash[:success] = "Client #{params[:id]} was updated."
      redirect_to admin_clients_path()
    else
      render :edit
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
  end
  
  private

  def search(term)
    Client.where("name || ' ' || address ILIKE ?", "%#{params[:term]}%").map { |t| t.attributes.merge({value: "#{t.name}, #{t.address}" }) }
  end

  def safe_params
    params.require(:client).permit(:id, :name, :address, :notes)
  end
  
end
