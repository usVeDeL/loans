require 'csv'
require 'action_view'

class InterestsWeeklyJob < ApplicationJob
  include ActionView::Helpers::NumberHelper
  queue_as :default

  def perform(*args)
    #create csv attachment file
    csv_report = CSV.generate(headers: true) do |csv|
      csv << ['nombre', 'ciclo', 'Pago capital', 'Pago interes', 'Pago semanal']
      Loan.active.each  do |l|
        csv << generate_row(l)
      end
    end
    InterestsWeeklyMailer.send_report(csv_report).deliver
  end

  def generate_row(l)
    [
      l.name,
      l.cycle,
      number_to_currency(l.sum_payment_capital, precision:2),
      number_to_currency(l.sum_payment_interest, precision:2),
      number_to_currency(l.sum_week_payment, precision:2)
    ]
  end
end