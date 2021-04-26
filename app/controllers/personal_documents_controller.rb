class PersonalDocumentsController < ApplicationController
  before_action :is_view_permitted?, only:[:edit, :create, :destroy, :update]

  def create
    @personal_document = PersonalDocument.new(personal_documents_params)
    @client = client
    @personal_documents = personal_documents

    if @personal_document.save
      create_log(
        "Se ha creado documentos para el client: #{@client.name} #{@client.last_name} #{@client.mother_last_name}."
      )

      flash[:success] = success_text
    end

    redirect_to edit_client_path(@client)
  end

  def edit
    @personal_document = personal_document
    @client = @personal_document.client

  end

  def update
    @personal_document = personal_document
    @client = client
    @personal_documents = personal_documents

    if @personal_document.update(personal_documents_params)
      create_log(
        "Se ha actualizado documentos  para el client: #{@client.name} #{@client.last_name} #{@client.mother_last_name}."
      )

      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to edit_client_path(@client)
    end
  end

  def destroy
    @personal_document = personal_document
    @client =  Client.find(personal_document.client_id)

    create_log(
      "Se ha eliminado documentos para el client: #{@client.name} #{@client.last_name} #{@client.mother_last_name}."
    )

    if personal_document.delete
      flash[:success] = success_text

      redirect_to controller: 'clients', action: 'edit', id: @client.id 
    else
      redirect_to edit_client_path(client)
    end
  end

  private

  def personal_documents_params
    params.require(:personal_document).permit(
      :document,
      :document_type_id, 
      :client_id
    )
  end

  def personal_document
    PersonalDocument.find(params[:id])
  end

  def client
    Client.find(personal_documents_params[:client_id])
  end

  def personal_documents
    client.personal_documents
  end
end
