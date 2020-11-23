class LoanClientsController < ApplicationController
  def create
    loan_client = LoanClient.new(amount: loan_client_params[:amount], client_id: client.id, group_id: 1, loan_id: loan_client_params[:loan_id])
    loan = Loan.find(loan_client_params[:loan_id])
    if loan_client.save
      amount = loan.loan_amount + loan_client_params[:amount].to_f
      weekly_amount = (amount/1000.0) * 75
      interest = (weekly_amount * 16) - amount
      warranty = amount * 0.1
      loan.update!(loan_amount: amount, interest_amount: interest, weekly_amount: weekly_amount, warranty: warranty)
      create_update_amortization_table(loan)
      @loan = loan
      @clients = @loan.clients
      @weekly_payments = WeeklyPayment.where(loan_id: loan.id).order('week ASC')
      
      respond_to do |format|
        format.js
      end
    else
      render loan_new_path
    end
  end

  def destroy
    loan_client = LoanClient.find(params[:id])
    loan = loan_client.loan
    if loan_client.delete
      amount = loan.loan_amount - loan_client.amount.to_f
      weekly_amount = (amount/1000.0) * 75
      interest = (weekly_amount * 16) - amount
      warranty = amount * 0.1
      loan.update!(loan_amount: amount, interest_amount: interest, weekly_amount: weekly_amount, warranty: warranty)
      create_update_amortization_table(loan) 
      
      @loan = loan
      @clients = @loan.clients
      @weekly_payments = WeeklyPayment.where(loan_id: loan.id).order('week ASC')
      respond_to do |format|
        format.js
      end

    else
      redirect_to edit_loan_path(loan)
    end
  end

  def self.create_update_amortization_table(loan)
    weekly_payments = loan.weekly_payments

    return create_weekly_payments(loan) if weekly_payments.blank?
      
    update_weekly_payments(loan, loan.weekly_payments.order('week ASC'))
  end

  def create_update_amortization_table(loan)
    weekly_payments = loan.weekly_payments

    return create_weekly_payments(loan) if weekly_payments.blank?
      
    update_weekly_payments(loan, loan.weekly_payments.order('week ASC'))
  end

  private

  def loan_client_params
    loan_params.permit(:amount, :loan_id, :name, :last_name, :mother_last_name, :birth_date)
  end

  def loan_params
    @loan_parmas ||= params.require(:loan_client)
  end

  def client
    @client ||= Client
    .where(name: loan_client_params[:name])
    .where(last_name: loan_client_params[:last_name])
    .where(mother_last_name: loan_client_params[:mother_last_name])
    .where(birth_date: loan_client_params[:birth_date]).last || Client.last
  end

  def create_weekly_payments(loan)
    (1..16).each do |n|
      week_payment = loan.weekly_amount
      percent_capital = capital_payment_table[n.to_s.to_sym]
      payment_capital = week_payment*(percent_capital/100.0)
      payment_capital = 0 if n == 1

      percent_interest = interest_payment_table[n.to_s.to_sym]
      payment_interest = week_payment*(percent_interest/100.0)
      balance_capital = loan.loan_amount - payment_capital
      balance_interest = loan.interest_amount - payment_interest
      total = loan.loan_amount + loan.interest_amount
      wallet_amout = total - week_payment if n == 1
      wallet_amout = WeeklyPayment.where(loan_id: loan.id).last.wallet_amout - week_payment if n > 1

      WeeklyPayment.create!(
        week: n,
        loan_id: loan.id,
        payment_date: (loan.start_date + (n-1).week),
        payment_capital: payment_capital,
        payment_interest: payment_interest,
        week_payment: week_payment,
        balance_capital: balance_capital,
        balance_interest: balance_interest,
        wallet_amout: wallet_amout,
        percent_capital: percent_capital,
        percent_interest: percent_interest,
      )

      LoanMovement.create!(movement_type_id: 2, amount: 0.0,loan_id: loan.id, week: n)
    end    
  end

  def self.create_weekly_payments(loan)
    (1..16).each do |n|
      week_payment = loan.weekly_amount
      percent_capital = capital_payment_table[n.to_s.to_sym]
      payment_capital = week_payment*(percent_capital/100.0)
      payment_capital = 0 if n == 1

      percent_interest = interest_payment_table[n.to_s.to_sym]
      payment_interest = week_payment*(percent_interest/100.0)
      balance_capital = loan.loan_amount - payment_capital
      balance_interest = loan.interest_amount - payment_interest
      total = loan.loan_amount + loan.interest_amount
      wallet_amout = total - week_payment if n == 1
      wallet_amout = WeeklyPayment.where(loan_id: loan.id).last.wallet_amout - week_payment if n > 1

      WeeklyPayment.create!(
        week: n,
        loan_id: loan.id,
        payment_date: (loan.start_date + (n-1).week),
        payment_capital: payment_capital,
        payment_interest: payment_interest,
        week_payment: week_payment,
        balance_capital: balance_capital,
        balance_interest: balance_interest,
        wallet_amout: wallet_amout,
        percent_capital: percent_capital,
        percent_interest: percent_interest,
      )

      LoanMovement.create!(
        movement_type: 2,
        amount: 0.0,
        loan_id: loan.id,
        week: n
      )
    end    
  end

  def self.update_weekly_payments(loan, payments)
    payments.each_with_index do |payment, index|
      n = index + 1
      payment_date = (loan.start_date + (n-1).week)
      week_payment = loan.weekly_amount
      percent_capital = capital_payment_table[n.to_s.to_sym]
      payment_capital = week_payment*(percent_capital/100.0)
      payment_capital = 0 if n == 1

      percent_interest = interest_payment_table[n.to_s.to_sym]
      payment_interest = week_payment*(percent_interest/100.0)
      balance_capital = loan.loan_amount - payment_capital
      balance_interest = loan.interest_amount - payment_interest

      total = loan.loan_amount + loan.interest_amount
      wallet_amout = total - week_payment if n == 1
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
    end   
  end

  def update_weekly_payments(loan, payments)
    payments.each_with_index do |payment, index|
      n = index + 1
      payment_date = (loan.start_date + (n-1).week)
      week_payment = loan.weekly_amount
      percent_capital = capital_payment_table[n.to_s.to_sym]
      payment_capital = week_payment*(percent_capital/100.0)
      payment_capital = 0 if n == 1

      percent_interest = interest_payment_table[n.to_s.to_sym]
      payment_interest = week_payment*(percent_interest/100.0)
      balance_capital = loan.loan_amount - payment_capital
      balance_interest = loan.interest_amount - payment_interest

      total = loan.loan_amount + loan.interest_amount
      wallet_amout = total - week_payment if n == 1
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
    end   
  end

  def self.interest_payment_table
    @interest_payment_table ||= {
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
  end

  def self.capital_payment_table
    @capital_payment_table ||= {
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
  end

  def interest_payment_table
    @interest_payment_table ||= {
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
  end

  def capital_payment_table
    @capital_payment_table ||= {
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
  end
end