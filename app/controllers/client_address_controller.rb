class ClientAddressController < ApplicationController
  def create
    @client_address = ClientAddress.new(client_addresss_params)
    @client = Client.find(client_addresss_params[:client_id])
    @client_addresses = @client.client_address

    if @client_address.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(client)
    end    
  end

  def edit
    @client_address = ClientAddress.find(params[:id])
    @client = @client_address.client
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @client_address = ClientAddress.find(params[:id])
    @client = Client.find(client_addresss_params[:client_id])
    @client_addresses = @client.client_address

    if @client_address.update(client_addresss_params)
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(@client)
    end    
  end

  def destroy
    client_address = ClientAddress.find(params[:id])
    @client = Client.find(client_address.client_id)
    @client_addresses = @client.client_address

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
end
