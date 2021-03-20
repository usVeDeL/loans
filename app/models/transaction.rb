class Transaction < ApplicationRecord
  belongs_to :loan_movement
  belongs_to :loan
end
