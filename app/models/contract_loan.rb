class ContractLoan < ApplicationRecord
  belongs_to :loan
  belongs_to :contract
end
