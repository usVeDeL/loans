class ContactTypesController < ApplicationController
  before_action :is_view_permitted?, only:[:new, :edit, :index, :destroy]
  
  def index
    @contact_types = ContactType.all
  end

  def new
    @contact_type = ContactType.new
  end

  def create
    @contact_type = ContactType.new(contact_type_params)

    if @contact_type.save
      flash[:success] = success_text

      redirect_to contact_types_path
    else
      render 'new'
    end
  end

  def edit
    @contact_type = contact_type
  end

  def update
    @contact_type = contact_type

    if @contact_type.update(contact_type_params)
      flash[:success] = success_text

      redirect_to contact_types_path
    else
      render 'edit'
    end
  end

  def destroy
    if contact_type.delete
      flash[:success] = success_text
    else
      flash[:danger] = error_text
    end

    redirect_to contact_types_path
  end

  private

  def contact_type_params
    params.require(:contact_type).permit(
      :name,
      :active
    )
  end

  def contact_type
    ContactType.find(params[:id])
  end
end
