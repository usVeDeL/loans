class AddIndexToLoans < ActiveRecord::Migration[6.0]
  def change
    add_index :loans, [:name, :cycle], unique: true
  end
end
