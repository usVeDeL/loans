class ClientsController < ApplicationController
  # before_action :is_view_permitted?, only:[:new, :edit, :index]

  def index
    @clients = Client.all
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      create_log("Se ha registrado un nuevo cliente: #{@client.name} #{@client.last_name} #{@client.mother_last_name}.")

      flash[:success] = success_text

      redirect_to clients_path
    else
      render 'new'
    end
  end

  def edit
    @client = client
    @client_addresses = @client.client_address
    @client_contact_types = @client.client_contact_types
    @personal_documents = @client.personal_documents
  end

  def update
    @client = client

    if @client.update(client_params)
      create_log("Se ha actualizado el cliente cliente: #{@client.name} #{@client.last_name} #{@client.mother_last_name}.")

      flash[:success] = success_text

      redirect_to clients_path
    else
      render 'edit'
    end
  end

  def destroy
    create_log("Se ha eliminado el cliente: #{client.name} #{client.last_name} #{client.mother_last_name}.")

    if client.delete
      flash[:success] = success_text
    else
      flash[:danger] = error_text
    end

    redirect_to clients_path
  end

  def add_client
    @client = Client.new(client_params)
    respond_to do |format|
      if @client.save
        flash[:success] = success_text

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
    params.require(:client).permit(
      :name,
      :last_name,
      :mother_last_name,
      :birth_date
    )
  end

  def client
    Client.find(params[:id])
  end
end
