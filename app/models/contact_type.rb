class ContactType < ApplicationRecord
    validates :name, uniqueness: { case_sensitive: false }, presence: true
    has_many :clients
    has_many :client_contact_types
end
