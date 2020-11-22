class DocumentType < ApplicationRecord
    validates :name, uniqueness: { case_sensitive: false }, presence: true
    has_one :personal_document
end
