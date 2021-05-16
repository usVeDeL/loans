class LoansController < ApplicationController
  before_action :is_view_permitted?, only:[:new, :edit, :index, :destroy]
  
  def index
    @filter = ''
    @filter = params[:filter] if params.key?(:filter)

    filter = @filter.to_sym
    @loans = Loan.index(filter)
  end

  def new
    @loan = Loan.new
  end

  def create
    @loan = Loan.new(loan_params)

    if @loan.save
      loan_table_amortization_update(@loan)
      LoanMailer.new_loan(@loan).deliver
      create_log("Se ha creado el grupo #{@loan.name}, ciclo: #{@loan.cycle}.")
      flash[:success] = success_text

      redirect_to edit_loan_path @loan
    else
      flash[:danger] = @loan.errors.full_messages.map{ |e| errors_map[e] || errors_map.values }.join(', ')

      render 'new'
    end
  end

  def edit
    @loan = Loan.find(params[:id])
    @clients = @loan.clients
    @weekly_payments = weekly_payments
    @client_movements = @loan.loan_movements.where('amount > 0')
    @last_weekly_payment = last_weekly_payment
    @avaiable_movements = (1..(@weekly_payments.last.week+1)).to_a - @loan.loan_movements.filter_map{|w| w.week if w.amount.to_f > 0.0  }.sort
  end

  def update
    @loan = Loan.find(params[:id])
    @clients = @loan.clients

    if @loan.update(loan_params)
      loan_table_amortization_update(@loan)
      @weekly_payments = weekly_payments
      @last_weekly_payment = last_weekly_payment
      create_log("Se ha actualizado el grupo #{@loan.name}, ciclo: #{@loan.cycle}.")

      flash[:success] = success_text
    end

    redirect_to edit_loan_path(@loan)
  end

  def pay_full
    @loan = Loan.find(params[:id])
    @clients = @loan.clients

    if @loan.update(state_id: 3)
      loan_table_amortization_update(@loan)
      @weekly_payments = weekly_payments
      @last_weekly_payment = last_weekly_payment

      flash[:success] = success_text
    end

    redirect_to edit_loan_path(@loan)
  end

  def destroy
    loan = Loan.find(params[:id])
    create_log("Se ha eliminado el grupo #{loan.name}, ciclo: #{loan.cycle}.")
    if loan.delete
      delete(loan)

      flash[:success] = success_text
    else
      flash[:danger] = error_text
    end

    redirect_to loans_path(@loan, filter: params[:filter])
  end

  private

  def loan_params
    params.require(:loan).permit(
      :name,
      :loan_amount,
      :interest_amount,
      :weekly_amount,
      :warranty,
      :start_date,
      :end_date,
      :state_id,
      :user_id,
      :interest_percent,
      :adviser_name,
      :disbursement_date,
      :cycle,
      :address_contract
    )
  end

  def loan_table_amortization_update(loan)
    BasePaymentsController.new(loan)
    loan.update_status
  end

  def errors_map
    {
      'Name has already been taken' => 'El nombre del grupo ya existe, ingresa otro'
    }
  end

  def delete(loan)
    loan&.loan_movements&.delete
    loan&.loan_clients&.delete
    loan&.weekly_payments&.delete
  end

  def last_weekly_payment
    @loan.last_weekly_payment
  end

  def weekly_payments
    @loan.weekly_payments.order('week ASC')
  end
end
