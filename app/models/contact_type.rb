class ContactType < ApplicationRecord
  has_many :clients
  has_many :client_contact_types

  validates :name, uniqueness: { case_sensitive: false }, presence: true
end
