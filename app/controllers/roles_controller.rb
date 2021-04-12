class RolesController < ApplicationController
  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)

    if @role.save
      flash[:success] = success_text

      redirect_to roles_path
    else
      render 'new'
    end
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])

    if @role.update(role_params)
      flash[:success] = success_text

      redirect_to roles_path
    else
      render 'edit'
    end
  end

  def destroy
    role = Role.find(params[:id])

    if role.delete
      flash[:success] = success_text

      redirect_to roles_path
    else
      flash[:danger] = error_text

      redirect_to roles_path
    end
  end

  private

  def role_params
    params.require(:role).permit(
      :name,
      :detail_loan,
      :group_loan,
      :state,
      :movement_type,
      :loan,
      :movement,
      :contact,
      :document_type,
      :contact_type,
      :address,
      :client,
      :configuration,
      :kind_type,
      :notification,
      :user,
      :profile
    )
  end
end
