class AddStateIdToPersonalGroupLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :personal_group_loans, :state_id, :integer, null: false, default: 1
  end
end
