class AddRolesFieldsToRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :roles, :can_view_client_address, :boolean, default: true
    add_column :roles, :can_delete_client_address, :boolean, default: false
    add_column :roles, :can_edit_client_address, :boolean, default: false
    add_column :roles, :can_create_client_address, :boolean, default: false

    add_column :roles, :can_view_client_contact_types, :boolean, default: true
    add_column :roles, :can_delete_client_contact_types, :boolean, default: false
    add_column :roles, :can_edit_client_contact_types, :boolean, default: false
    add_column :roles, :can_create_client_contact_types, :boolean, default: false

    add_column :roles, :can_view_clients, :boolean, default: true
    add_column :roles, :can_delete_clients, :boolean, default: false
    add_column :roles, :can_edit_clients, :boolean, default: false
    add_column :roles, :can_create_clients, :boolean, default: false

    add_column :roles, :can_view_contact_types, :boolean, default: true
    add_column :roles, :can_delete_contact_types, :boolean, default: false
    add_column :roles, :can_edit_contact_types, :boolean, default: false
    add_column :roles, :can_create_contact_types, :boolean, default: false

    add_column :roles, :can_view_contracts, :boolean, default: true
    add_column :roles, :can_delete_contracts, :boolean, default: false
    add_column :roles, :can_edit_contracts, :boolean, default: false
    add_column :roles, :can_create_contracts, :boolean, default: false

    add_column :roles, :can_view_document_types, :boolean, default: true
    add_column :roles, :can_delete_document_types, :boolean, default: false
    add_column :roles, :can_edit_document_types, :boolean, default: false
    add_column :roles, :can_create_document_types, :boolean, default: false

    add_column :roles, :can_view_loan_clients, :boolean, default: true
    add_column :roles, :can_delete_loan_clients, :boolean, default: false
    add_column :roles, :can_edit_loan_clients, :boolean, default: false
    add_column :roles, :can_create_loan_clients, :boolean, default: false

    add_column :roles, :can_view_loan_movements, :boolean, default: true
    add_column :roles, :can_delete_loan_movements, :boolean, default: false
    add_column :roles, :can_edit_loan_movements, :boolean, default: false
    add_column :roles, :can_create_loan_movements, :boolean, default: false

    add_column :roles, :can_view_loans, :boolean, default: true
    add_column :roles, :can_delete_loans, :boolean, default: false
    add_column :roles, :can_edit_loans, :boolean, default: false
    add_column :roles, :can_create_loans, :boolean, default: false

    add_column :roles, :can_view_movement_types, :boolean, default: true
    add_column :roles, :can_delete_movement_types, :boolean, default: false
    add_column :roles, :can_edit_movement_types, :boolean, default: false
    add_column :roles, :can_create_movement_types, :boolean, default: false

    add_column :roles, :can_view_personal_documents, :boolean, default: true
    add_column :roles, :can_delete_personal_documents, :boolean, default: false
    add_column :roles, :can_edit_personal_documents, :boolean, default: false
    add_column :roles, :can_create_personal_documents, :boolean, default: false
    
    add_column :roles, :can_view_roles, :boolean, default: true
    add_column :roles, :can_delete_roles, :boolean, default: false
    add_column :roles, :can_edit_roles, :boolean, default: false
    add_column :roles, :can_create_roles, :boolean, default: false

    add_column :roles, :can_view_states, :boolean, default: true
    add_column :roles, :can_delete_states, :boolean, default: false
    add_column :roles, :can_edit_states, :boolean, default: false
    add_column :roles, :can_create_states, :boolean, default: false

    add_column :roles, :can_view_users, :boolean, default: true
    add_column :roles, :can_delete_users, :boolean, default: false
    add_column :roles, :can_edit_users, :boolean, default: false
    add_column :roles, :can_create_users, :boolean, default: false  
  end
end
