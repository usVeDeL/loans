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
      BasePaymentsController.create_update_amortization_table(loan)
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
      BasePaymentsController.create_update_amortization_table(loan)
      
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
end