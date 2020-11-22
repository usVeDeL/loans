class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
  
    if @client.save
      flash[:success] = "Cambios guardados correctamente"
      redirect_to clients_path
    else
      render 'new'
    end
  end

  def edit
    @client = Client.find(params[:id])
    @client_addresses = @client.client_address
    @client_contact_types = @client.client_contact_types
    @personal_documents = @client.personal_documents
  end

  def update
    @client = Client.find(params[:id])

    if @client.update(client_params)
      flash[:success] = "Cambios guardados correctamente"
      redirect_to clients_path
    else
      render 'edit'
    end
  end

  def destroy
    client = Client.find(params[:id])

    if client.delete
      flash[:success] = 'Cambios guardados correctamente'
      redirect_to clients_path
    else
      flash[:danger] = 'Error... algo salio mal'
      redirect_to clients_path
    end
  end

  def add_client
    @client = Client.new(client_params)
    respond_to do |format|
      if @client.save
        flash[:success] = "Cambios guardados correctamente"
        format.js
      else
        format.html {	render :index }
      end
    end
  end

  def search_clients
    q = params[:q]
    @clients = Client.where('name LIKE ? OR last_name LIKE ? OR mother_last_name  LIKE ?', "%#{q}%", "%#{q}%", "%#{q}%")

    respond_to do |format|
        format.js
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :last_name, :mother_last_name, :birth_date)
  end
end
