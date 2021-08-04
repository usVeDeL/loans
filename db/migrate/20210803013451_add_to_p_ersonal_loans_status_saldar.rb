class AddToPErsonalLoansStatusSaldar < ActiveRecord::Migration[6.0]
  def change
    add_column :personal_group_loans, :finished_amount, :decimal, null: false, default: 0.0
  end
end
