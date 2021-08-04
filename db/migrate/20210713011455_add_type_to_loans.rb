class AddTypeToLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :type, :string, null: false, default: ''
  end
end
