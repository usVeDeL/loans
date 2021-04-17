class ClientAddressController < ApplicationController
  before_action :is_view_permitted?, only:[:create, :edit]

  def create
    @client_address = ClientAddress.new(client_addresss_params)
    @client = client
    @client_addresses = address_from_client

    create_log("Se ha creado el domicilio del cliente: #{@client.name} #{@client.last_name} #{@client.mother_last_name}.")
    if @client_address.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(client)
    end
  end

  def edit
    @client_address = client_address
    @client = @client_address.client

    respond_to do |format|
      format.js
    end
  end

  def update
    @client_address = client_address
    @client = client
    @client_addresses = address_from_client

    if @client_address.update(client_addresss_params)
      create_log("Se ha actualizado el domicilio del cliente: #{@client.name} #{@client.last_name} #{@client.mother_last_name}.")
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(@client)
    end
  end

  def destroy
    @client = Client.find(client_address.client_id)
    @client_addresses = address_from_client
    create_log("Se ha eliminado el domicilio del cliente: #{@client.name} #{@client.last_name} #{@client.mother_last_name}.")

    if client_address.delete
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(client)
    end
  end

  private

  def client_addresss_params
    params.require(:client_address).permit(
      :state_name,
      :town,
      :neighborhood,
      :code_zip,
      :street,
      :number_exterior,
      :number_interior,
      :client_id
    )
  end

  def client_address
    ClientAddress.find(params[:id])
  end

  def client
    Client.find(client_addresss_params[:client_id])
  end

  def address_from_client
    @client.client_address
  end
end
