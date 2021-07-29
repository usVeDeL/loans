class Client < ApplicationRecord
  has_many :client_address
  has_many :contact_types
  has_many :client_contact_types
  has_many :personal_documents
  has_many :loan_clients
  has_many :loans, through: :loan_clients

  def fullname
    "#{self.name} #{self.last_name} #{self.mother_last_name}"
  end
end