class AddWeekToLoanMovement < ActiveRecord::Migration[6.0]
  def change
    add_column :loan_movements, :week, :integer
  end
end
