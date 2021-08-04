class PersonalGroupLoan < ApplicationRecord
	has_many :loan_movement_personal_groups
	has_many :payment_personal_groups
	belongs_to :client
	belongs_to :state

	scope :order_desc, -> { order('created_at DESC') }
  scope :pending, -> { where(state_id: 1).order_desc }
  scope :active, -> { where(state_id: 2).order_desc }
  scope :pending_finish, -> { where(state_id: 4).order_desc }
  scope :finished, -> { where(state_id: 3).order_desc }

	enum status: {
    pending_accept: 'pending_accept',
    pending_pay: 'pending_pay',
    paid: 'paid',
    not_paid: 'not_paid'
  }

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

	def self.index(filter=nil)
    case filter
    when :active
      PersonalGroupLoan.pending + PersonalGroupLoan.active
    when :finished
      PersonalGroupLoan.finished
    else
      PersonalGroupLoan.all
    end
  end

	def update_status
    status = if self.state.name == 'pending'
      :pending_accept
    elsif self.pending_payment == true
      :pending_pay
    elsif self.movements_sum >= self.payments_sum 
      :paid 
    elsif self.not_paid_past_due_date == true
      :not_paid
    else
      :paid
    end
    
    self.update(status: status)

    status
  end

	def pending_payment
    payments_before_today.where(status: 'danger').count > 0 && DateTime.now.between?(self.start_date, self.end_date)
  end

	def payments_before_todayweekly_payments
    self.payment_personal_groups.where('payment_date < ?', DateTime.now)
  end

	def movements_sum
    movements_order_asc.sum(:amount)
  end

	def movements_order_asc
    movements_before_today.order('period ASC')
  end

	def movements_before_today
    self.loan_movement_personal_groups.where('period <= ?', self.payments_last_period)
  end

	def payments_last_period
    payments_order_asc.last&.period
  end

	def payments_order_asc
    payments_before_today.order('period ASC')
  end

	def payments_before_today
    self.payment_personal_groups.where('payment_date < ?', DateTime.now)
  end

	def payments_sum
    payments_order_asc.sum(:period_amount)
  end

	def not_paid_past_due_date
    DateTime.now > self.end_date && self.movements_sum < self.payments_sum 
  end

  def last_weekly_payment
    movements_sum = self.loan_movement_personal_groups.sum(:amount)

    self.sum_payment_amount - movements_sum
  end
end
