class AdjustPayments
  def initialize(loan, params)
    @loan = loan
    @params = params

    adjust_loan
  end

  private

  attr_reader :loan, :params

  def adjust_loan
    payments = @loan.payment_personal_groups
    payments_hash = {}

    payments.each do |payment|
      payments_hash[payment.id] = {
        period: payment.period,
        personal_group_loan_id: @loan.id,
        payment_date: (@loan.start_date + (payment.period - 1).month),
        capital_amount: @loan.capital_amount,
        interest_amount: interest_payment(payment),
        period_amount: @loan.payment_amount,
        status: payment.update_status
      }
      
      
    end

    PaymentPersonalGroup.update(payments_hash.keys, payments_hash.values)
      @loan.update!(
        sum_interest: (@loan.interest_monthly * @loan.payments_number).round(2),
        sum_capital: @loan.amount,
        sum_payment_amount: (@loan.amount + ((@loan.interest_monthly * @loan.payments_number).round(2))).round(2)
      )
  end

  def interest_payment(payment)
    return @loan.interest_monthly if payment.payment_date < DateTime.now

    days = (DateTime.now.to_date payment.payment_date.to_date).to_i
    interest_amount = 0.025 * days
    (@loan.interest_monthly + interest_amount).round(2)
  end
end
