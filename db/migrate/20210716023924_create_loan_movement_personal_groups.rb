class CreateLoanMovementPersonalGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :loan_movement_personal_groups do |t|
      t.string :movement_type_id, null: false
      t.decimal :amount, null: false, precision: 14, scale: 2
      t.integer :personal_group_loan_id 
      t.integer :period 
      t.string :comments

      t.timestamps
    end
  end
end
