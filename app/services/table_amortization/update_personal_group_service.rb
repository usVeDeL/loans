module TableAmortization
  class UpdatePersonalGroupService
    include ActionView::Helpers::NumberHelper
    
    def initialize(loan)
			@loan = loan
    end

    def execute
      update_payments
    end

    private

    def update_payments
      payments = @loan.payment_personal_groups.order('period asc')
      payments_hash = {}
      sum_interest = 0

      payments.each do |payment|
        payments_hash[payment.id] = {
          period: payment.period,
          personal_group_loan_id: @loan.id,
          payment_date: (@loan.start_date + (payment.period - 1).month),
          capital_amount: @loan.capital_amount,
          interest_amount: interest_payment(payment),
          period_amount: @loan.capital_amount + interest_payment(payment),
          status: payment.update_status
        }

        sum_interest += interest_payment(payment)
      end

      PaymentPersonalGroup.update(payments_hash.keys, payments_hash.values)
      @loan.update!(
        sum_interest: sum_interest,
        sum_capital: (@loan.interest_monthly * @loan.payments_number).round(2),
        sum_payment_amount: (sum_interest + ((@loan.interest_monthly * @loan.payments_number).round(2))).round(2)
      )
    end

    def interest_payment(payment)
      return @loan.interest_monthly unless payment.payment_date < DateTime.now
  
      days = (DateTime.now.to_date - payment.payment_date.to_date).to_i
      interest_amount = 0.025 * days
      (@loan.interest_monthly + interest_amount).round(2)
    end
	end    
end
