class Loan < ApplicationRecord
  has_many :loan_clients
  has_many :loan_movements
  has_many :clients, through: :loan_clients
  belongs_to :state
  has_many :weekly_payments
  has_many :contract_loans
  has_many :contracts, through: :contract_loans

  validates :name, uniqueness: { case_sensitive: false }, presence: true
end
