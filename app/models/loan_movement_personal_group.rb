class LoanMovementPersonalGroup < ApplicationRecord
    belongs_to :personal_group_loan
    belongs_to :movement_type

    def fill_other_movements(amount)
			amount = amount.to_f
			movements = self.personal_group_loan.loan_movement_personal_groups.where('period <= ?', self.period).order(period: :asc)

			payment_amount = self.personal_group_loan.payment_amount
			movements_last_period = movements.last.period
	
			movements.each do |m|
				next if payment_amount == m.amount && m.period < movements_last_period
	
				if movements_last_period == m.period
					m.update(amount: amount)
					amount = 0
				elsif m.amount > payment_amount
					difference_amount = m.amount - payment_amount
					m.update(amount: payment_amount)
					amount += difference_amount
				elsif amount >= payment_amount
					if m.amount.positive?
						amount -= payment_amount - m.amount
						m.update(amount: payment_amount)
					else
						m.update(amount: payment_amount)
						amount -= payment_amount
					end
				elsif amount < payment_amount && amount.positive?
					new_amount = m.amount + amount
					if new_amount > payment_amount
						m.update(amount: payment_amount )
						amount = new_amount - payment_amount
					else
						m.update(amount: new_amount)
						amount = 0
					end
				else
					m.update(amount: m.amount)
					amount = 0
				end
			end
		end
end
