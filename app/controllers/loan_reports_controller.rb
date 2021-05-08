class LoanReportsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  MONTHS = {
    '01' => 'Enero',
    '02' => 'Febrero',
    '03' => 'Marzo',
    '04' => 'Abril',
    '05' => 'Mayo',
    '06' => 'Junio',
    '07' => 'Julio',
    '08' => 'Agosto',
    '09' => 'Septiembre',
    '10' => 'Octubre',
    '11' => 'Noviembre',
    '12' => 'Diciembre'
  }

  def recents
    @last_six_months = last_six_months
    @loans = loans_recents
    @sums = {
      amount: number_to_currency(@loans.sum(:loan_amount), precision:2),
      weekly_amount: number_to_currency(@loans.sum(:weekly_amount), precision:2)
    }
  end

  def extensions
    @last_six_months = last_six_months
    @loans = loans_extensions
    @sums = {
      amount: number_to_currency(@loans.sum(:loan_amount), precision:2),
      weekly_amount: number_to_currency(@loans.sum(:weekly_amount), precision:2)
    }
  end

  private

  def last_six_months
    (0..6).to_a.map{ |n| ["#{MONTHS[n.month.ago.strftime('%m')]}-#{n.month.ago.strftime('%Y')}", n.month.ago.strftime('%Y-%m-01')]}
  end

  def loans_recents
    month = Date.today.at_beginning_of_month
    month = params[:month].to_date if params.key?(:month) 
    @month_name = "#{MONTHS[month.to_date.strftime('%m')]}-#{month.to_date.strftime('%Y')}"

    Loan.where(cycle: 1).where(disbursement_date: month..month.end_of_month).order('disbursement_date DESC')
  end

  def loans_extensions
    month = Date.today.at_beginning_of_month
    month = params[:month].to_date if params.key?(:month) 
    @month_name = "#{MONTHS[month.to_date.strftime('%m')]}-#{month.to_date.strftime('%Y')}"

    Loan.where('cycle > 1').where(disbursement_date: month..month.end_of_month).order('disbursement_date DESC')
  end
end
