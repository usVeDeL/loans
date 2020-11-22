class PersonalDocument < ApplicationRecord
  mount_uploader :document, FileUploader
  belongs_to :client
  belongs_to :document_type
end
