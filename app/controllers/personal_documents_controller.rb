class PersonalDocumentsController < ApplicationController
  before_action :is_view_permitted?, only:[:edit, :create, :destroy, :update]

  def create
    @personal_document = PersonalDocument.new(personal_documents_params)
    @client = client
    @personal_documents = personal_documents

    if @personal_document.save
      create_log(
        "Se ha creado documentos #{@personal_document.name} para el client: #{@client.name} #{@client.last_name} #{@client.mother_last_name}."
      )
    end

    redirect_to edit_client_path(@client)
  end

  def edit
    @personal_document = personal_document
    @client = @personal_document.client

    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    @personal_document = personal_document
    @client = client
    @personal_documents = personal_documents

    if @personal_document.update(personal_documents_params)
      create_log(
        "Se ha actualizado documentos #{@personal_document.name} para el client: #{@client.name} #{@client.last_name} #{@client.mother_last_name}."
      )

      flash[:success] = success_text

      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to edit_client_path(@client)
    end
  end

  def destroy
    @client = client
    @personal_documents = personal_documents

    create_log(
      "Se ha eliminado documentos para el client: #{@client.name} #{@client.last_name} #{@client.mother_last_name}."
    )

    if personal_document.delete
      respond_to do |format|
        format.js
        format.html
      end
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
    Client.find(personal_documents_params[:client_id]) ||
      Client.find(personal_document.client_id)
  end

  def personal_documents
    client.personal_documents
  end
end
