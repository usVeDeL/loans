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
      payments = @loan.payment_personal_groups
      payments_hash = {}

      payments.each do |payment|
        payments_hash[payment.id] = {
            period: payment.period,
            personal_group_loan_id: @loan.id,
            payment_date: (@loan.start_date + (payment.period - 1).month),
            capital_amount: @loan.capital_amount,
            interest_amount: @loan.interest_monthly,
            period_amount: @loan.payment_amount,
            status: 'light'
          }
      end

      PaymentPersonalGroup.update(payments_hash.keys, payments_hash.values)
      @loan.update!(
        sum_interest: (@loan.interest_monthly * @loan.payments_number).round(2),
        sum_capital: @loan.amount,
        sum_payment_amount: (@loan.payment_amount * @loan.payments_number).round(2)
      )
    end
	end    
end
