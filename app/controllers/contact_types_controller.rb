class ContactTypesController < ApplicationController
  def index
    @contact_types = ContactType.all
  end

  def new
    @contact_type = ContactType.new
  end

  def create
    @contact_type = ContactType.new(contact_type_params)

    if @contact_type.save
      flash[:success] = "Cambios guardados correctamente"
      redirect_to contact_types_path
    else
      render 'new'
    end
  end

  def edit
    @contact_type = ContactType.find(params[:id])
  end

  def update
    @contact_type = ContactType.find(params[:id])

    if @contact_type.update(contact_type_params)
      flash[:success] = "Cambios guardados correctamente"
      redirect_to contact_types_path
    else
      render 'edit'
    end
  end

  def destroy
    contact_type = ContactType.find(params[:id])

    if contact_type.delete
      flash[:success] = 'Cambios guardados correctamente'
      redirect_to contact_types_path
    else
      flash[:danger] = 'Error... algo salio mal'
      redirect_to contact_types_path
    end
  end

  private

  def contact_type_params
    params.require(:contact_type).permit(:name, :active)
  end
end
