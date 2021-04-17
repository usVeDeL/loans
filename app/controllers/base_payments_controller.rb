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

  def initialize(loan)
    @loan = loan

    create_update_amortization_table
  end


  def create_update_amortization_table
    return CreateWeeklyPaymentsController.new(@loan).execute if loan_weekly_payments.blank?


    UpdateWeeklyPaymentsController.new(@loan).execute 
  end

  private

  attr_reader :loan

  def loan_weekly_payments
    @loan_weekly_payments ||= loan&.weekly_payments&.order('week ASC')
  end

  def weekly_payment_exist?
    loan.weekly_payments.where(week: @week).count > 0
  end

  def percent_capital
    table_week = @week > 16 ? 17 : @week 

    CAPITAL_PAYMENT_TABLE[table_week.to_s.to_sym]
  end

  def percent_interest
    table_week = @week > 16 ? 17 : @week

    INTEREST_PAYMENT_TABLE[table_week.to_s.to_sym]
  end

  def payment_interest
    loan_weekly_amount * ( percent_interest.to_f / 100.0 )
  end

  def balance_capital
    loan.loan_amount - payment_capital
  end

  def balance_interest
    loan.interest_amount - payment_interest
  end

  def start_date
    return 0 if loan.start_date&.nil?
    
    loan.start_date
  end

  def create_loan_movement
    LoanMovement.create!(movement_type_id: 2, amount: 0.0,loan_id: loan.id, week: @week)
  end
end