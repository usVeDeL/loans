class DocumentType < ApplicationRecord
  has_one :personal_document
  
  validates :name, uniqueness: { case_sensitive: false }, presence: true
end
