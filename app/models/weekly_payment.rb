class WeeklyPayment < ApplicationRecord
  belongs_to :loan

  def loan_movement
    self.loan.loan_movements.where(week: self.week).last
  end
end
