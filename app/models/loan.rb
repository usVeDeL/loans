class Loan < ApplicationRecord
  has_many :loan_clients
  has_many :loan_movements
  has_many :clients, through: :loan_clients
  belongs_to :state
  has_many :weekly_payments
  has_many :contract_loans
  has_many :contracts, through: :contract_loans

  scope :order_desc, -> { order('created_at DESC') }
  scope :pending, -> { where(state_id: 1).order_desc }
  scope :active, -> { where(state_id: 2).order_desc }
  scope :finished, -> { where(state_id: 3).order_desc }

  def self.index(filter=nil)
    case filter
    when :pending
      Loan.list(pending)
    when :active
      Loan.list(active)
    when :finished
      Loan.list(finished)
    else
      Loan.list(order_desc)
    end
  end

  def self.list(loans_filtered)
    loans = []
    loans_filtered.each do |loan|
      loans << {
        loan: loan,
        status: loan.status
      }
    end
    
    loans
  end

  def pending_last_payment_bool
    movements_before_today.where('week < ?', payments_last_week).where('amount < ?', payments_before_today.last&.week_payment).count == 0 && movements_before_today.last&.amount.to_f < payments_before_today.last&.week_payment.to_f
  end

  def last_payment_bool
    payments_before_today.last&.payment_date.to_i > 1.week.ago.to_i
  end

  def payments_before_today
    self.weekly_payments.where('payment_date < ?', DateTime.now)
  end

  def movements_before_today
    self.loan_movements.where('week <= ?', self.payments_last_week)
  end

  def payments_sum
    payments_order_asc.sum(:week_payment)
  end

  def movements_sum
    movements_order_asc.sum(:amount)
  end

  def payments_order_asc
    payments_before_today.order('week ASC')
  end

  def movements_order_asc
    movements_before_today.order('week ASC')
  end

  def payments_last_week
    payments_order_asc.last&.week
  end
  
  def status
    if self.movements_sum >= self.payments_sum 
      'success' 
    elsif self.pending_last_payment_bool
      'warning'
    elsif self.last_payment_bool == true
      'danger' 
    else 
      'light'
    end
  end
end
