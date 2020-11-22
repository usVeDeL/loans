class CreateWeeklyPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_payments do |t|
      t.integer :week
      t.integer :loan_id
      t.datetime :payment_date
      t.float :payment_capital
      t.float :payment_interest
      t.float :week_payment
      t.float :balance_capital
      t.float :balance_interest
      t.float :wallet_amout
      t.float :percent_capital
      t.float :percent_interest

      t.timestamps
    end
  end
end
