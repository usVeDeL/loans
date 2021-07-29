class LoanMovementPersonalGroupsController < ApplicationController
	def create
		if movement_params[:movement_type_id] == '2'
			@loan = loan
			movement = movements.find_by(period: movement_params[:period])

			if movement.update(
				amount: movement_params[:amount], 
				personal_group_loan_id: movement_params[:loan_id], 
				movement_type_id: movement_params[:movement_type_id], 
				comments: movement_params[:comments]
			)
      AdjustLoansController.new(loan, movement_params)
			@movements = @loan.loan_movement_personal_groups.where('amount > 0')
			@payments = @loan.payment_personal_groups
      @payments.where(period: movement_params[:period]).last.update_status
				respond_to do |format|
					format.js
				end
			end
		end
	end

	def update
    loan_movement = LoanMovementPersonalGroup.find(params[:id])
    loan_movement.fill_other_movements(params[:amount])
    @loan = loan_movement.personal_group_loan

    if params[:movement_type_id] == '2'
      adjust_payment
    end

    @movements = @loan.loan_movement_personal_groups.where('amount > 0')
    @payments = @loan.payment_personal_groups.order('period ASC')
    @payments.where(period: loan_movement.period).last.update_status
    # TODO We have to update this
    #@last_weekly_payment = @loan.last_weekly_payment
  end

  def destroy
    @loan_movement = LoanMovementPersonalGroup.find(params[:id])
    @loan = @loan_movement.personal_group_loan

    if @loan_movement.update(amount: 0.0)
      adjust_payment
      @movements = @loan.loan_movement_personal_groups.where('amount > 0')
      @payments = @loan.payment_personal_groups.order('period ASC')
      @payments.where(period: @loan_movement.period).last.update_status
     # @last_weekly_payment = @loan.last_weekly_payment
      respond_to do |format|
        format.js
      end
    end
  end

	def edit
    payment = PaymentPersonalGroup.find(params[:id])
		binding.pry
    @loan_movement = LoanMovementPersonalGroup.where(loan_id: payment.loan_id).where(movement_type_id: 2).where(week: payment.week).last
    
		respond_to do |format|
      format.js
    end
  end

  def adjust_payment
    loan_movement = LoanMovementPersonalGroup.find(params[:id])

    if params.key?(:comments)
      loan_movement.update!(comments: params[:comments])
    end
  end

	private 

  def movement_params
    params.require(:loan_movement_personal_group).permit(
      :amount, 
      :loan_id, 
      :movement_type_id, 
      :comments,
      :period
    )
  end

	def loan
		PersonalGroupLoan.find(movement_params[:loan_id])
	end

	def movements
		@loan
			.loan_movement_personal_groups
			.where(movement_type_id: movement_params[:movement_type_id])			
  end
end
