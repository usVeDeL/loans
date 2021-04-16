class ClientContactTypesController < ApplicationController
  before_action :is_view_permitted?, only:[:edit, :destroy]

  def create
    @client_contact_type = ClientContactType.new(client_contact_types_params)
    @client = client
    @client_contact_types = client_contact_types

    if @client_contact_type.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(client)
    end
  end

  def edit
    @client_contact_type = client_contact_type
    @client = @client_contact_type.client

    respond_to do |format|
      format.js
    end
  end

  def update
    @client_contact_type = client_contact_type
    @client = client
    @client_contact_types = client_contact_types

    if @client_contact_type.update(client_contact_types_params)
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(@client)
    end
  end

  def destroy
    client_contact_type = client_contact_type
    @client = Client.find(client_contact_type.client_id)
    @client_contact_types = client_contact_types

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

  def client_contact_type
    ClientContactType.find(params[:id])
  end

  def client_contact_types
    client.client_contact_types
  end
  
  def client
    Client.find(client_contact_types_params[:client_id])
  end
end
