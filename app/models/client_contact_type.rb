class ClientContactType < ApplicationRecord
  belongs_to :client
  belongs_to :contact_type
end
