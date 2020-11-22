class PersonalDocumentsController < ApplicationController
  def create
    @personal_document = PersonalDocument.new(personal_documents_params)
    @client = Client.find(personal_documents_params[:client_id])
    @personal_documents = @client.personal_documents

    if @personal_document.save
      redirect_to edit_client_path(@client)
    else
      redirect_to edit_client_path(@client)
    end    
  end

  def edit
    @personal_document = PersonalDocument.find(params[:id])
    @client = @personal_document.client
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @personal_document = PersonalDocument.find(params[:id])
    @client = Client.find(personal_documents_params[:client_id])
    @personal_documents = @client.personal_documents

    if @personal_document.update(personal_documents_params)
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(@client)
    end    
  end

  def destroy
    personal_document = PersonalDocument.find(params[:id])
    @client = Client.find(personal_document.client_id)
    @personal_documents = @client.personal_documents

    if personal_document.delete
      respond_to do |format|
        format.js
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
end
