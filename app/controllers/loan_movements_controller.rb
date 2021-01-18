class LoanMovementsController < ApplicationController
  def create
    movements = LoanMovement.where(loan_id: movement_params[:loan_id]).where(movement_type_id: movement_params[:movement_type_id])
    payments = WeeklyPayment.where(loan_id: movement_params[:loan_id])
    payment_week = payments.where("payment_date <= ?", DateTime.now).order('id DESC').first&.week
    movement = movements.find_by(week: payment_week)
    @loan = Loan.find(movement_params[:loan_id])
    if movement_params[:movement_type_id] == '2'
      if movement.update(movement_params)
        
        adjust_loan
        @client_movements = @loan.loan_movements.where("amount > 0")
        @weekly_payments = @loan.weekly_payments.order('week ASC')
        @last_weekly_payment = last_weekly_payment

        respond_to do |format|
          format.js
        end
      else
        redirect_to edit_client_path(@client)
      end    
    else
      LoanMovement.create(movement_params)
      @client_movements = @loan.loan_movements.where("amount > 0")
      @weekly_payments = @loan.weekly_payments.order('week ASC')
      @last_weekly_payment = last_weekly_payment

      respond_to do |format|
        format.js
      end
    end
  end

  def edit
    payment = WeeklyPayment.find(params[:id])
    @loan_movement = LoanMovement.where(loan_id: payment.loan_id).where(movement_type_id: 2).where(week: payment.week).last
    respond_to do |format|
      format.js
    end
  end

  def update
    loan_movement = LoanMovement.find(params[:id])
    loan_movement.update(amount: params[:amount])
    @loan = loan_movement.loan
    if params[:movement_type_id] == '2'
      adjust_payment
    end
    @weekly_payments = @loan.weekly_payments.order('week ASC')
    @client_movements = @loan.loan_movements.where("amount > 0")
    @last_weekly_payment = last_weekly_payment
  end

  def destroy
    @loan_movement = LoanMovement.find(params[:id])
    @loan = @loan_movement.loan
    

    if @loan_movement.update(amount: 0.0)
      adjust_payment
      @weekly_payments = @loan.weekly_payments.order('week ASC')
      @client_movements = @loan.loan_movements.where("amount > 0")
      @last_weekly_payment = last_weekly_payment
      respond_to do |format|
        format.js
      end
    else
      redirect_to edit_client_path(client)
    end
  end

  def adjust_loan
    loan = Loan.find(movement_params[:loan_id])
    payments = WeeklyPayment.where(loan_id: movement_params[:loan_id])

    payment_week = payments.where("payment_date <= ?", DateTime.now).order('id DESC').first&.week || 0

    payments.each do |payment|
      if payment.week >= payment_week
        week_payment = payment.week_payment 
        week_payment = movement_params[:amount].to_f if payment.week == payment_week
        percent_capital = capital_payment_table[payment.week.to_s.to_sym]
        
        payment_capital = week_payment*(percent_capital/100.0)
        payment_capital = 0 if payment.week == 1

        percent_interest = interest_payment_table[payment.week.to_s.to_sym]
        payment_interest = week_payment*(percent_interest/100.0)
        
        balance_capital = payments.find_by(week: (payment.week-1)).balance_capital - payment_capital if payment.week > 1
        balance_capital = loan.loan_amount - payment_capital if payment.week == 1

        balance_interest = payments.find_by(week: (payment.week-1)).balance_interest - payment_interest if payment.week > 1
        balance_interest = loan.interest_amount - payment_interest if payment.week == 1

        total = loan.loan_amount + loan.interest_amount
        wallet_amout = total - week_payment if payment.week == 1
        wallet_amout = payments.find_by(week: (payment.week-1)).wallet_amout - week_payment if payment.week > 1

        payment.update!(
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
  end


  def adjust_payment
    loan_movement = LoanMovement.find(params[:id])
    loan_id = params[:loan_id] || loan_movement.loan_id
    amount = params[:amount] || loan_movement.amount
    loan = Loan.find(loan_id)
    payments = WeeklyPayment.where(loan_id: loan_id)
    payment_week = loan_movement.week || 0
    
    if params.has_key?(:comments)
      loan_movement.update(comments: params[:comments])
    end

    payments.each do |payment|
      if payment.week >= payment_week
        week_payment = payment.week_payment 
        week_payment = amount.to_f if payment.week == payment_week
        percent_capital = capital_payment_table[payment.week.to_s.to_sym]
        
        payment_capital = week_payment*(percent_capital/100.0)
        payment_capital = 0 if payment.week == 1

        percent_interest = interest_payment_table[payment.week.to_s.to_sym]
        payment_interest = week_payment*(percent_interest/100.0)
        
        balance_capital = payments.find_by(week: (payment.week-1)).balance_capital - payment_capital if payment.week > 1
        balance_capital = loan.loan_amount - payment_capital if payment.week == 1

        balance_interest = payments.find_by(week: (payment.week-1)).balance_interest - payment_interest if payment.week > 1
        balance_interest = loan.interest_amount - payment_interest if payment.week == 1

        total = loan.loan_amount + loan.interest_amount
        wallet_amout = total - week_payment if payment.week == 1
        wallet_amout = payments.find_by(week: (payment.week-1)).wallet_amout - week_payment if payment.week > 1

        payment.update!(
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
  end

  private

  def movement_params
    params.require(:loan_movement).permit(:amount, :loan_id, :movement_type_id, :comments)
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

  def last_weekly_payment
    payments = @loan.weekly_payments
    last_payment = nil
    payments.order('id ASC').each_with_index do |weekly_payment, index|
      last_payment = weekly_payment if weekly_payment.loan_movement.amount > 0 || index == 0
    end
    
    last_payment&.wallet_amout - (@loan.loan_amount/10)
  end
end
