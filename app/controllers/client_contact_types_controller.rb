class ClientContactTypesController < ApplicationController
  def create
    @client_contact_type = ClientContactType.new(client_contact_types_params)
    @client = Client.find(client_contact_types_params[:client_id])
    @client_contact_types = @client.client_contact_types

    if @client_contact_type.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(client)
    end    
  end

  def edit
    @client_contact_type = ClientContactType.find(params[:id])
    @client = @client_contact_type.client
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @client_contact_type = ClientContactType.find(params[:id])
    @client = Client.find(client_contact_types_params[:client_id])
    @client_contact_types = @client.client_contact_types

    if @client_contact_type.update(client_contact_types_params)
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(@client)
    end    
  end

  def destroy
    client_contact_type = ClientContactType.find(params[:id])
    @client = Client.find(client_contact_type.client_id)
    @client_contact_types = @client.client_contact_types

    if client_contact_type.delete
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(client)
    end
  end

  private

  def client_contact_types_params
    params.require(:client_contact_type).permit(
      :details,
      :contact_type_id, 
      :client_id
    )
  end
end
