class LoanMovement < ApplicationRecord
  belongs_to :loan
  belongs_to :movement_type

  def weekly_payment
    self.loan.weekly_payments.where(week: self.week).last
  end
end
