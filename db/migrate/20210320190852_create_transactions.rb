class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.integer :loan_id
      t.integer :loan_movement_id
      t.integer :week

      t.timestamps
    end
  end
end
