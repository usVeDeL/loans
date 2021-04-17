class DocumentTypesController < ApplicationController
  before_action :is_view_permitted?, only:[:new, :edit, :index, :destroy]

  def index
    @document_types = DocumentType.all
  end

  def new
    @document_type = DocumentType.new
  end

  def create
    @document_type = DocumentType.new(document_type_params)

    if @document_type.save
      flash[:success] = success_text

      redirect_to document_types_path
    else
      render 'new'
    end
  end

  def edit
    @document_type = document_type
  end

  def update
    @document_type = document_type

    if @document_type.update(document_type_params)
      flash[:success] = success_text

      redirect_to document_types_path
    else
      render 'edit'
    end
  end

  def destroy
    if document_type.delete
      flash[:success] = success_text
    else
      flash[:danger] = error_text
    end

    redirect_to document_types_path
  end

  private

  def document_type_params
    params.require(:document_type).permit(
      :name,
      :active,
      :required
    )
  end

  def document_type
    DocumentType.find(params[:id])
  end
end
