class User < ApplicationRecord
  belongs_to :role
  has_many :logs

  delegate :name,
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
    :can_create_users,
    to: :role, prefix: true


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable,
         authentication_keys: [:login]

  validates :username, uniqueness: { case_sensitive: false }, presence: true
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  attr_writer :login

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  def login
    @login || self.username
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions&.dup
    if login = conditions&.delete(:login)
      where(conditions).where(["username = :value", { :value => login }])&.first
    elsif conditions&.has_key?(:username)
      conditions[:username]&.downcase! if conditions[:username]
      where(conditions.to_h)&.first
    end
  end

  def gravatar_url
    'https://panndora-topics.s3.us-east-2.amazonaws.com/logo.png'
  end

  def is_admin?
    self.role == 'admin'
  end
end
