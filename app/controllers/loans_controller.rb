class LoansController < ApplicationController
  def index
    @loans = Loan.where.not(state_id: 3).order("created_at DESC")
  end

  def new
    @loan = Loan.new
  end

  def create
    @loan = Loan.new(loan_params)
  
    if @loan.save
      create_weekly_payments(@loan)
      flash[:success] = "Cambios guardados correctamente"
      redirect_to edit_loan_path @loan
    else
      flash[:danger] = @loan.errors.full_messages.map{ |e| errors_map[e] }.join(', ')

      render 'new'
    end
  end

  def edit
    @loan = Loan.find(params[:id])
    @clients = @loan.clients
    @weekly_payments = @loan.weekly_payments.order('week ASC')
    @client_movements = @loan.loan_movements.where("amount > 0")
  end

  def update
    @loan = Loan.find(params[:id])
    @clients = @loan.clients

    if @loan.update(loan_params)
      LoanClientsController.create_update_amortization_table(@loan)
      @weekly_payments = @loan.weekly_payments.order('week ASC')
      flash[:success] = "Cambios guardados correctamente"
    
      redirect_to edit_loan_path @loan
    else
      redirect_to edit_loan_path @loan
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:name, :loan_amount, :interest_amount, :weekly_amount, :warranty, :start_date, :end_date, :state_id, :user_id, :interest_percent, :adviser_id, :cycle, :address_contract)
  end

  def errors_map
    {
      'Name has already been taken' => 'El nombre del grupo ya existe, ingresa otro'
    }
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
