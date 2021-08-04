class CreatePersonalGroupStrategy
	def initialize(params)
		@params = params
	end

	def execute
		return false unless create_loan
		return false unless create_table_amortization
		
		@loan
	end

	private

	def create_loan
		@loan = PersonalGroupLoan.create!(loan_params)
	end

	def create_table_amortization
		TableAmortization::CreatePersonalGroupService.new(@loan).execute
	end

	def loan_params
		{
			client_id: @params[:client_id],
			amount: @params[:amount],
			interest_percent: @params[:interest_percent],
			interest_monthly: interest_monthly,
			capital_amount: capital_amount,
			payment_amount: payment_amount,
			payments_number: @params[:payments_number],
			frecuency: @params[:frecuency],
			start_date: @params[:start_date],
			end_date: end_date,
			adviser_name: @params[:adviser_name],
			disbursement_date: @params[:disbursement_date],
			address_contract: @params[:address_contract],
			status: @params[:status]
		}
	end

	def end_date
		@params[:start_date].to_date + @params[:payments_number].to_i.month
	end

	def interest_monthly
		(@params[:amount].to_f * (@params[:interest_percent].to_f/100)).round(2)
	end

	def capital_amount
		(@params[:amount].to_f/@params[:payments_number].to_i).round(2)
	end

	def payment_amount
		(capital_amount + interest_monthly).round(2)
	end
end