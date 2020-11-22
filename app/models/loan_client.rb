class LoanClient < ApplicationRecord
  belongs_to :loan 
  belongs_to :client
end
