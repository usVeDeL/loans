require 'csv'
require 'action_view'

class InterestsWeeklyJob < ApplicationJob
  include ActionView::Helpers::NumberHelper
  queue_as :default

  def perform(*args)
    # if Date.today.strftime("%A") == 'Sunday'
      #create csv attachment file
      csv_report = CSV.generate(headers: true) do |csv|
        csv << ['grupo', 'ciclo', 'Pago capital', 'Pago interes', 'Pago semanal']
        transactions.each  do |l|
          csv << generate_row(l)
        end
      end
      InterestsWeeklyMailer.send_report(csv_report).deliver
    # end
  end

  def generate_row(l)
    [
      l.loan.name,
      l.loan.cycle,
      number_to_currency(l&.loan_movement&.weekly_payment&.payment_interest, precision:2),
      number_to_currency(l&.loan_movement&.weekly_payment&.payment_capital, precision:2),
      number_to_currency(l&.loan_movement&.weekly_payment&.week_payment, precision:2)
    ]
  end

  def transactions
    Transaction.where(updated_at: 7.days.ago..Time.current)
  end
end