class LoanMovement < ApplicationRecord
  belongs_to :loan
  belongs_to :movement_type
end
