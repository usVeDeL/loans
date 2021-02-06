class LoansController < ApplicationController
  def index
    @filter = ''
    @filter = params[:filter] if params.has_key?(:filter)

    filter = @filter.to_sym
    @loans = Loan.index(filter)
  end

  def new
    @loan = Loan.new
  end

  def create
    @loan = Loan.new(loan_params)
  
    if @loan.save
      BasePaymentsController.create_update_amortization_table(@loan)
      @loan.update_status
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
    @last_weekly_payment = @loan.last_weekly_payment
    BasePaymentsController.create_update_amortization_table(@loan)
    @loan.update_status
  end

  def update
    @loan = Loan.find(params[:id])
    @clients = @loan.clients

    if @loan.update(loan_params)
      BasePaymentsController.create_update_amortization_table(@loan)
      @loan.update_status
      @weekly_payments = @loan.weekly_payments.order('week ASC')
      @last_weekly_payment = @loan.last_weekly_payment
      flash[:success] = "Cambios guardados correctamente"
    
      redirect_to edit_loan_path(@loan)
    else
      redirect_to edit_loan_path(@loan)
    end
  end

  def pay_full
    @loan = Loan.find(params[:id])
    @clients = @loan.clients

    if @loan.update(state_id: 3)
      BasePaymentsController.create_update_amortization_table(@loan)
      @loan.update_status
      if @loan.state_id == 3
        @loan.loan_movements.each do |payment|
          payment.update!(amount: @loan.weekly_amount)
        end
      end

      @weekly_payments = @loan.weekly_payments.order('week ASC')
      @last_weekly_payment = @loan.last_weekly_payment
      flash[:success] = "Cambios guardados correctamente"
    
      redirect_to edit_loan_path(@loan)
    else
      redirect_to edit_loan_path(@loan)
    end
  end

  def destroy
    loan = Loan.find(params[:id])

    if loan.delete
      loan&.loan_movements&.delete
      loan&.loan_clients&.delete
      loan&.weekly_payments&.delete

      flash[:success] = "Préstamo eliminado correctamente"
      redirect_to loans_path(@loan, filter: params[:filter])
    else
      flash[:danger] = "Hubo un error al eliminar el préstamo"
      redirect_to loans_path(@loan, filter: params[:filter])
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:name, :loan_amount, :interest_amount, :weekly_amount, :warranty, :start_date, :end_date, :state_id, :user_id, :interest_percent, :adviser_name, :disbursement_date, :cycle, :address_contract)
  end

  def errors_map
    {
      'Name has already been taken' => 'El nombre del grupo ya existe, ingresa otro'
    }
  end
end
