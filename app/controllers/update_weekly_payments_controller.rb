class UpdateWeeklyPaymentsController < BasePaymentsController
  def initialize(loan)
    @loan = loan
  end

  def execute
    update_weekly_payments
  end

  private

  attr_reader :loan

  def update_weekly_payments
    loan_weekly_payments.each_with_index do |payment, index|
      @week = index + 1
      @payment = payment
      # binding.pry
      @payment.update!(
        week: @week,
        loan_id: loan.id,
        payment_date: (start_date + index.week),
        payment_capital: payment_capital,
        payment_interest: payment_interest,
        week_payment: loan_weekly_amount,
        balance_capital: balance_capital,
        balance_interest: balance_interest,
        wallet_amout: wallet_amount,
        percent_capital: percent_capital,
        percent_interest: percent_interest
      )

      payment.update_status
    end

    loan.update_loan_sums
  end

  def loan_weekly_amount
    return @payment&.loan_movement&.amount.to_f if @week > 1
    
    loan.weekly_amount
  end

  def payment_capital
    loan_weekly_amount * ( percent_capital.to_f / 100.0 )
  end

  def total
    (loan.loan_amount + loan.interest_amount) - loan_weekly_amount
  end

  def wallet_amount
    return total if @week == 1

    last_weekly_payment.wallet_amout - loan_weekly_amount
  end
end