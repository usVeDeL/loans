class DocumentTypesController < ApplicationController
  def index
    @document_types = DocumentType.all
  end

  def new
    @document_type = DocumentType.new
  end

  def create
    @document_type = DocumentType.new(document_type_params)
  
    if @document_type.save
      flash[:success] = "Cambios guardados correctamente"
      redirect_to document_types_path
    else
      render 'new'
    end
  end

  def edit
    @document_type = DocumentType.find(params[:id])
  end

  def update
    @document_type = DocumentType.find(params[:id])

    if @document_type.update(document_type_params)
      flash[:success] = "Cambios guardados correctamente"
      redirect_to document_types_path
    else
      render 'edit'
    end
  end

  def destroy
    document_type = DocumentType.find(params[:id])

    if document_type.delete
      flash[:success] = 'Cambios guardados correctamente'
      redirect_to document_types_path
    else
      flash[:danger] = 'Error... algo salio mal'
      redirect_to document_types_path
    end
  end

  private

  def document_type_params
    params.require(:document_type).permit(:name, :active, :required)
  end
end
