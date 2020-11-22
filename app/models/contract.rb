class Contract < ApplicationRecord
  has_many :contract_loans
  has_many :loans, through: :contract_loans
end
