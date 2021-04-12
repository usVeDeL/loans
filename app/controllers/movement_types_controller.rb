class MovementTypesController < ApplicationController
  def index
    @movement_types = MovementType.all
  end

  def new
    @movement_type = MovementType.new
  end

  def create
    @movement_type = MovementType.new(movement_type_params)

    if @movement_type.save
      flash[:success] = success_text

      redirect_to movement_types_path
    else
      render 'new'
    end
  end

  def edit
    @movement_type = movement_type
  end

  def update
    @movement_type = MovementType.find(params[:id])

    if @movement_type.update(movement_type_params)
      flash[:success] = success_text

      redirect_to movement_types_path
    else
      render 'edit'
    end
  end

  def destroy
    if movement_type.delete
      flash[:success] = success_text
    else
      flash[:danger] = error_text
    end

    redirect_to movement_types_path
  end

  private

  def movement_type_params
    params.require(:movement_type).permit(
      :name,
      :active,
      :kind_type
    )
  end

  def movement_type
    MovementType.find(params[:id])
  end
end
