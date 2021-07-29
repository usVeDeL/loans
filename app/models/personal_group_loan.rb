class PersonalGroupLoan < ApplicationRecord
	has_many :loan_movement_personal_groups
	has_many :payment_personal_groups
	belongs_to :client
	belongs_to :state

	scope :order_desc, -> { order('created_at DESC') }
  scope :pending, -> { where(state_id: 1).order_desc }
  scope :active, -> { where(state_id: 2).order_desc }
  scope :finished, -> { where(state_id: 3).order_desc }
end
