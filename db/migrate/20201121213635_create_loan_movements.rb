class CreateLoanMovements < ActiveRecord::Migration[6.0]
  def change
    create_table :loan_movements do |t|
      t.integer :movement_type_id
      t.float :amount
      t.integer :loan_id

      t.timestamps
    end
  end
end
