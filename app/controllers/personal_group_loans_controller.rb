class PersonalGroupLoansController < ApplicationController
  def new
    @loan = PersonalGroupLoan.new
  end

  def create
    loan = CreatePersonalGroupStrategy.new(params[:personal_group_loan]).execute

    if loan
      create_log("Se ha creado el prestamo personal grupal #{loan.client.fullname}.")
      flash[:success] = success_text

      redirect_to edit_personal_group_loan_path loan
    else
      flash[:danger] = loan.errors.full_messages.map{ |e| errors_map[e] || errors_map.values }.join(', ')

      render 'new'
    end
  end

  def edit
    @loan = PersonalGroupLoan.find(params[:id])
    @payments = @loan.payment_personal_groups
    @movements = @loan.loan_movement_personal_groups.where('amount > 0')
  end

  def update
    loan = PersonalGroupLoan.find(params[:id])
    loan = Strategy::UpdatePersonalGroup.new(loan: loan, params: params[:personal_group_loan]).execute

    if loan
      create_log("Se ha actualizado el prestamo personal grupal #{loan.client.fullname}.")
      flash[:success] = success_text

      redirect_to edit_personal_group_loan_path loan
    else
      flash[:danger] = loan.errors.full_messages.map{ |e| errors_map[e] || errors_map.values }.join(', ')

      render 'new'
    end
  end

  def index
    @loans = PersonalGroupLoan.all.order('created_at DESC')
  end

  def destroy
    loan = PersonalGroupLoan.find(params[:id])
    if loan.delete
      delete(loan)

      flash[:success] = success_text
    else
      flash[:danger] = error_text
    end

    redirect_to personal_group_loans_path(@loan)
  end
end
