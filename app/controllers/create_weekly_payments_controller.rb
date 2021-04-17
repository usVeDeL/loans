class CreateWeeklyPaymentsController < BasePaymentsController
  def initialize(loan)
    @loan = loan
  end

  def execute
    create_weekly_payments
  end

  def create_weekly_payment(week)
    @week = week.to_i

    WeeklyPayment.create!(
      week: @week,
      loan_id: loan.id,
      payment_date: (start_date + (@week-1).week),
      payment_capital: payment_capital,
      payment_interest: payment_interest,
      week_payment: loan_weekly_amount,
      balance_capital: balance_capital,
      balance_interest: balance_interest,
      wallet_amout: wallet_amount,
      percent_capital: percent_capital,
      percent_interest: percent_interest,
    )
  end

  private

  attr_reader :loan

  def create_weekly_payments
    (1..16).each do |index|
      next if weekly_payment_exist?

      payment = create_weekly_payment(index)

      create_loan_movement
      
      payment.update_status
    end

    loan.update_loan_sums
  end

  def loan_weekly_amount    
    loan.weekly_amount
  end

  def payment_capital
    return 0 if @week == 1

    loan_weekly_amount * ( percent_capital.to_f / 100.0 )
  end

  def total
    loan.loan_amount + loan.interest_amount
  end

  def wallet_amount
    return total if @week == 1

    WeeklyPayment.where(loan_id: loan.id).last.wallet_amout - loan_weekly_amount    
  end
end