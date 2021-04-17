class RolesController < ApplicationController
  before_action :is_view_permitted?, only:[:new, :edit, :index, :destroy]
  
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
      :can_view_client_address,
      :can_delete_client_address,
      :can_edit_client_address,
      :can_create_client_address,
      :can_view_client_contact_types,
      :can_delete_client_contact_types,
      :can_edit_client_contact_types,
      :can_create_client_contact_types,
      :can_view_clients,
      :can_delete_clients,
      :can_edit_clients,
      :can_create_clients,
      :can_view_contact_types,
      :can_delete_contact_types,
      :can_edit_contact_types,
      :can_create_contact_types,
      :can_view_contracts,
      :can_delete_contracts,
      :can_edit_contracts,
      :can_create_contracts,
      :can_view_document_types,
      :can_delete_document_types,
      :can_edit_document_types,
      :can_create_document_types,
      :can_view_loan_clients,
      :can_delete_loan_clients,
      :can_edit_loan_clients,
      :can_create_loan_clients,
      :can_view_loan_movements,
      :can_delete_loan_movements,
      :can_edit_loan_movements,
      :can_create_loan_movements,
      :can_view_loans,
      :can_delete_loans,
      :can_edit_loans,
      :can_create_loans,
      :can_view_movement_types,
      :can_delete_movement_types,
      :can_edit_movement_types,
      :can_create_movement_types,
      :can_view_personal_documents,
      :can_delete_personal_documents,
      :can_edit_personal_documents,
      :can_create_personal_documents,
      :can_view_roles,
      :can_delete_roles,
      :can_edit_roles,
      :can_create_roles,
      :can_view_states,
      :can_delete_states,
      :can_edit_states,
      :can_create_states,
      :can_view_users,
      :can_delete_users,
      :can_edit_users,
      :can_create_users
    )
  end
end
