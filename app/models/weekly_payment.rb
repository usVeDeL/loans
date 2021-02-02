class WeeklyPayment < ApplicationRecord
  belongs_to :loan

  enum status: {
    success: 'success',
    danger: 'danger',
    warning: 'warning',
    light: 'light'
  }

  def loan_movement
    self.loan&.loan_movements&.where(week: self.week)&.last
  end

  def update_status
    payment = self.payment_date > 1.week.ago && self.loan_movement&.amount.to_f <= 0 ? self.week_payment : self.loan_movement&.amount

    status = if self.loan_movement.nil? || payment.nil?
      'light'
    elsif self.loan.state_id == 3
      'success' 
    elsif self.payment_date >= DateTime.now 
      'light'
    elsif payment < self.loan.weekly_amount && self.payment_date < 1.week.ago
      'danger'
    elsif self.loan_movement&.amount < self.loan.weekly_amount
      'warning'
    elsif payment >= self.loan.weekly_amount
      'success'
    elsif self.payment_date > 1.week.ago
      'warning'
    else
      'light'
    end

    self.update(status: status)
  end

  def week_payment_amount
    self.loan_movement&.amount.to_f <= 0.1 ? self.week_payment.to_f : self.loan_movement&.amount.to_f
  end
end
