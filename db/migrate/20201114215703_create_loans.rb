class CreateLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :loans do |t|
      t.string :name
      t.float :loan_amount, default: 0.0
      t.float :interest_amount, default: 0.0
      t.float :weekly_amount, default: 0.0
      t.float :warranty, default: 0.0
      t.datetime :start_date
      t.datetime :end_date
      t.integer :state_id, default: 1
      t.integer :user_id
      t.float :interest_percent, default: 0.0
      t.integer :adviser_id
      t.integer :cycle

      t.timestamps
    end
  end
end
