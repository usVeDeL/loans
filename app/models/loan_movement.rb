class LoanMovement < ApplicationRecord
  belongs_to :loan
  belongs_to :movement_type

  def weekly_payment
    self.loan.weekly_payments.where(week: self.week).last
  end

  def fill_other_movements(amount)
    amount = amount.to_f
    movements = self.loan.loan_movements.where('week <= ?', self.week).order(week: :asc)
    weekly_amount = self.loan.weekly_amount
    movements_last_week = movements.last.week
    
    movements.each do |m|
      next if weekly_amount == m.amount && m.week < movements_last_week

      if movements_last_week == m.week
        m.update(amount: amount)
        amount = 0
      elsif m.amount > weekly_amount
        difference_amount = m.amount - weekly_amount
        m.update(amount: weekly_amount)
        amount = amount + difference_amount
      elsif amount >= weekly_amount
        m.update(amount: weekly_amount)
        amount = amount - weekly_amount
      elsif amount < weekly_amount && amount > 0
        new_amount = m.amount + amount
        if new_amount > weekly_amount
          m.update(amount: weekly_amount )
          amount = new_amount - weekly_amount
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
