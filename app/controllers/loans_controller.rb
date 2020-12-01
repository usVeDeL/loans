class LoansController < ApplicationController
  def index
    filter = params.has_key?(:filter)
    if filter
      case filter
      when 'active'
        @loans = Loan.where('state_id < 3').order("created_at DESC")
      when 'finished'
        @loans = Loan.where(state_id: 3).order("created_at DESC")
      else
        @loans = Loan.all.order("created_at DESC")
      end      
    else
      @loans = Loan.all.order("created_at DESC")
    end
  end

  def new
    @loan = Loan.new
  end

  def create
    @loan = Loan.new(loan_params)
  
    if @loan.save
      BasePaymentsController.create_update_amortization_table(@loan)
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
      BasePaymentsController.create_update_amortization_table(@loan)
      if @loan.state_id == 3
        @loan.loan_movements.each do |payment|
          payment.update!(amount: @loan.weekly_amount)
        end
      end

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
end
