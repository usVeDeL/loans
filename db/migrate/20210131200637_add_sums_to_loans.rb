class AddSumsToLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :sum_payment_capital, :decimal, default: 0
    add_column :loans, :sum_payment_interest, :decimal, default: 0
    add_column :loans, :sum_week_payment, :decimal, default: 0
  end
end
