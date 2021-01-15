class PersonalDocument < ApplicationRecord
  belongs_to :client
  belongs_to :document_type

  mount_uploader :document, FileUploader
end
