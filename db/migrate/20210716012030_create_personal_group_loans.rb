class CreatePersonalGroupLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :personal_group_loans do |t|
      t.integer :client_id, null: false
      t.decimal :amount, null: false, precision: 14, scale: 2
      t.decimal :interest_percent, null: false, precision: 14, scale: 2
      t.decimal :interest_monthly, null: false, precision: 14, scale: 2
      t.decimal :capital_amount, null: false, precision: 14, scale: 2
      t.decimal :payment_amount, null: false, precision: 14, scale: 2
      t.decimal :sum_interest, precision: 14, scale: 2
      t.decimal :sum_capital, precision: 14, scale: 2
      t.decimal :sum_payment_amount, precision: 14, scale: 2
      t.integer :payments_number, null: false
      t.string :frecuency, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :adviser_name
      t.datetime :disbursement_date
      t.string :address_contract
      t.string :status

      t.timestamps
    end
  end
end
