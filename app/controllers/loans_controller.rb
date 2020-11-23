class LoansController < ApplicationController
  def index
    @loans = Loan.all.order('start_date DESC')
  end

  def new
    @loan = Loan.new
  end

  def create
    @loan = Loan.new(loan_params)
  
    if @loan.save!
      flash[:success] = "Cambios guardados correctamente"
      redirect_to edit_loan_path @loan
    else
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
      render 'edit'
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:name, :loan_amount, :interest_amount, :weekly_amount, :warranty, :start_date, :end_date, :state_id, :user_id, :interest_percent, :adviser_id, :cycle)
  end
end
