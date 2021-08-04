module Strategy
	class UpdatePersonalGroup
		def initialize(**params)
			@loan = params[:loan]
			@update_params = params[:params]
		end
	
		def execute
			return false unless update_loan
			return false unless create_table_amortization
			
			@loan
		end
	
		private
	
		def update_loan
			@loan.update!(loan_params)
		end
	
		def create_table_amortization
			TableAmortization::UpdatePersonalGroupService.new(@loan).execute
		end
	
		def loan_params
			{
				client_id: @update_params[:client_id] || @loan.client_id,
				amount: @update_params[:amount] || @loan.amount,
				interest_percent: @update_params[:interest_percent] || @loan.interest_percent,
				interest_monthly: interest_monthly || @loan.interest_monthly,
				capital_amount: capital_amount || @loan.capital_amount,
				payment_amount: payment_amount || @loan.payment_amount,
				payments_number: @update_params[:payments_number] || @loan.payments_number,
				frecuency: @update_params[:frecuency] || @loan.frecuency,
				start_date: @update_params[:start_date] || @loan.start_date,
				end_date: end_date || @loan.end_date,
				adviser_name: @update_params[:adviser_name] || @loan.adviser_name,
				disbursement_date: @update_params[:disbursement_date] || @loan.disbursement_date,
				address_contract: @update_params[:address_contract] || @loan.address_contract,
				status: @update_params[:status] || @loan.status,
				state_id: @update_params[:state_id] || @loan.state_id,
				finished_amount: @update_params[:finished_amount] || @loan.finished_amount
			}
		end
	
		def end_date
			return @loan.start_date unless @update_params.key?(:start_date)

			@update_params[:start_date].to_date + @update_params[:payments_number].to_i.month
		end
	
		def interest_monthly
			return @loan.interest_monthly unless @update_params.key?(:interest_monthly)

			(@update_params[:amount].to_f * (@update_params[:interest_percent].to_f/100)).round(2)
		end
	
		def capital_amount
			return @loan.capital_amount unless @update_params.key?(:capital_amount)

			(@update_params[:amount].to_f/@update_params[:payments_number].to_i).round(2)
		end
	
		def payment_amount
			return @loan.payment_amount unless @update_params.key?(:payment_amount)

			(capital_amount + interest_monthly).round(2)
		end
	end
end
