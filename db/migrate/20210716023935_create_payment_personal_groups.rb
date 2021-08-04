class CreatePaymentPersonalGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_personal_groups do |t|
      t.integer :period
      t.integer :personal_group_loan_id
      t.datetime :payment_date
      t.decimal :capital_amount, precision: 14, scale: 2
      t.decimal :interest_amount, precision: 14, scale: 2
      t.decimal :period_amount, precision: 14, scale: 2
      t.decimal :balance_capital, precision: 14, scale: 2
      t.decimal :balance_interest, precision: 14, scale: 2
      t.decimal :wallet_amount, precision: 14, scale: 2
      t.decimal :percent_capital, precision: 14, scale: 2
      t.decimal :percent_interest, precision: 14, scale: 2
      t.string :status

      t.timestamps
    end
  end
end
