class AddStatusToWeeklyPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :weekly_payments, :status, :string
  end
end
