class BasePaymentsController < ApplicationController
  INTEREST_PAYMENT_TABLE = {
    '1': 29.71,
    '2': 28.15,
    '3': 26.55,
    '4': 24.92,
    '5': 23.24,
    '6': 21.53,
    '7': 19.79,
    '8': 18.0,
    '9': 16.18,
    '10': 14.31,
    '11': 12.40,
    '12': 10.45,
    '13': 8.46,
    '14': 6.42,
    '15': 4.34,
    '16': 2.21
  }

  CAPITAL_PAYMENT_TABLE = {
    '1': 70.29,
    '2': 71.85,
    '3': 73.45,
    '4': 75.08,
    '5': 76.76,
    '6': 78.47,
    '7': 80.21,
    '8': 82.0,
    '9': 83.82,
    '10': 85.69,
    '11': 87.60,
    '12': 89.55,
    '13': 91.54,
    '14': 93.58,
    '15': 95.66,
    '16': 97.79
  }


  def self.create_update_amortization_table(loan)
    payments = loan&.weekly_payments&.order('week ASC')

    return self.create_weekly_payments(loan) if payments.blank?

    self.update_weekly_payments(loan: loan, payments: payments)
  end


  def self.create_weekly_payments(loan)
    (1..16).each do |n|
      next if loan.weekly_payments.where(week: n).count > 0

      week_payment = loan.weekly_amount
      percent_capital = CAPITAL_PAYMENT_TABLE[n.to_s.to_sym]
      payment_capital = week_payment*(percent_capital.to_f/100.0)
      payment_capital = 0 if n == 1

      percent_interest = INTEREST_PAYMENT_TABLE[n.to_s.to_sym]
      payment_interest = week_payment*(percent_interest.to_f/100.0)
      balance_capital = loan.loan_amount - payment_capital
      balance_interest = loan.interest_amount - payment_interest
      total = loan.loan_amount + loan.interest_amount
      wallet_amout = total if n == 1
      wallet_amout = WeeklyPayment.where(loan_id: loan.id).last.wallet_amout - week_payment if n > 1
      start_date = loan.start_date
      start_date = 0 if start_date&.nil?


      payment = WeeklyPayment.create!(
        week: n,
        loan_id: loan.id,
        payment_date: (start_date + (n-1).week),
        payment_capital: payment_capital,
        payment_interest: payment_interest,
        week_payment: week_payment,
        balance_capital: balance_capital,
        balance_interest: balance_interest,
        wallet_amout: wallet_amout,
        percent_capital: percent_capital,
        percent_interest: percent_interest,
      )


      payment.save!
      LoanMovement.create!(movement_type_id: 2, amount: 0.0,loan_id: loan.id, week: n)
      payment.update_status
    end    

    loan.update_loan_sums
  end

  def self.update_weekly_payments(loan:, payments:)
    payments.each_with_index do |payment, index|
      n = index + 1
      payment_date = (loan.start_date + (n-1).week)

      week_payment = loan.weekly_amount
      week_payment = payment&.loan_movement&.amount.to_f if n > 1

      percent_capital = CAPITAL_PAYMENT_TABLE[n.to_s.to_sym]
      payment_capital = week_payment*(percent_capital.to_f/100.0)

      percent_interest = INTEREST_PAYMENT_TABLE[n.to_s.to_sym]
      payment_interest = week_payment*(percent_interest.to_f/100.0)
      balance_capital = loan.loan_amount - payment_capital
      balance_interest = loan.interest_amount - payment_interest

      total = (loan.loan_amount + loan.interest_amount) - week_payment
      wallet_amout = total if n == 1
      wallet_amout = WeeklyPayment.where(loan_id: loan.id, week: index).last.wallet_amout - week_payment if n > 1

      payment.update!(
        week: n,
        loan_id: loan.id,
        payment_date: payment_date,
        payment_capital: payment_capital,
        payment_interest: payment_interest,
        week_payment: week_payment,
        balance_capital: balance_capital,
        balance_interest: balance_interest,
        wallet_amout: wallet_amout,
        percent_capital: percent_capital,
        percent_interest: percent_interest,
      )
      
      payment.update_status
    end
    
    loan.update_loan_sums
  end
end