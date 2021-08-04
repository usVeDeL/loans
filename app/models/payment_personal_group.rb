class PaymentPersonalGroup < ApplicationRecord
    belongs_to :personal_group_loan

    enum status: {
      success: 'success',
      danger: 'danger',
      warning: 'warning',
      light: 'light'
    }


    def loan_movement_personal_group
      self.personal_group_loan&.loan_movement_personal_groups&.where(period: self.period)&.last
    end

    def update_status
      payment = self.payment_date > 1.month.ago && self.loan_movement_personal_group&.amount.to_f <= 0 ? self.period_amount : self.loan_movement_personal_group&.amount
  
      status = if self.loan_movement_personal_group.nil? || payment.nil?
        'light'
      elsif self.personal_group_loan.state_id == 3
        'success' 
      elsif self.payment_date >= DateTime.now 
        'light'
      elsif payment < self.personal_group_loan.payment_amount && self.payment_date < 1.month.ago
        'danger'
      elsif self.loan_movement_personal_group&.amount < self.personal_group_loan.payment_amount
        'warning'
      elsif payment >= self.personal_group_loan.payment_amount
        'success'
      elsif self.payment_date > 1.month.ago
        'warning'
      else
        'light'
      end
  
      status
    end

    def payment_amount
      self.loan_movement_personal_group&.amount.to_f <= 0.1 ? self.period_amount.to_f : self.loan_movement_personal_group&.amount.to_f
    end
end
