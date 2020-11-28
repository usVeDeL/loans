class AddDetailsToLoanMovement < ActiveRecord::Migration[6.0]
  def change
    add_column :loan_movements, :comments, :string
  end
end
