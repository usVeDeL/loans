class AdjustLoansController < ApplicationController
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
    '16': 2.21,
    '17': 1.10
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
    '16': 97.79,
    '17': 98.90
  }

  def initialize(loan, params)
    @loan = loan
    @params = params

    adjust_loan
  end

  private

  attr_reader :loan, :params

  def adjust_loan
    loan_weekly_payments.each do |payment|
      @payment = payment

      if @payment.week >= recent_payment_week
        @payment.update!(
          payment_capital: payment_capital,
          payment_interest: payment_interest,
          week_payment: week_payment_amount,
          balance_capital: balance_capital,
          balance_interest: balance_interest,
          wallet_amout: wallet_amount,
          percent_capital: percent_capital,
          percent_interest: percent_interest,
        )

        @payment.update_status
      end
    end

    loan.update_loan_sums
  end

  def loan_weekly_payments
    loan&.weekly_payments&.order('week ASC')
  end

  def recent_payment_week
    loan_weekly_payments.where('payment_date <= ?', DateTime.now).order('id DESC').first&.week || 0
  end

  def week_payment_amount
    return params[:amount].to_f if @payment.week == recent_payment_week

    @payment.week_payment 
  end

  def week
    return  17 if @payment.week > 16

    @payment.week
  end

  def percent_capital
    CAPITAL_PAYMENT_TABLE[week.to_s.to_sym] 
  end

  def payment_capital
    return 0 if @payment.week == 1

    week_payment_amount * (percent_capital.to_f / 100.0)
  end

  def percent_interest
    INTEREST_PAYMENT_TABLE[week.to_s.to_sym]
  end

  def payment_interest
    week_payment_amount * (percent_interest.to_f / 100.0)
  end

  def balance_capital
    return loan.loan_amount - payment_capital if @payment.week == 1

    loan_weekly_payments.find_by(week: (@payment.week-1)).balance_capital - payment_capital
  end

  def  balance_interest
    return loan.interest_amount - payment_interest if @payment.week == 1 

    loan_weekly_payments.find_by(week: (@payment.week-1)).balance_interest - payment_interest
  end

  def total
    loan.loan_amount + loan.interest_amount
  end

  def wallet_amount
    return total - week_payment_amount if @payment.week == 1
    
    loan_weekly_payments.find_by(week: (@payment.week-1)).wallet_amout - week_payment_amount
  end
end
