class AddAdviserNameToLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :adviser_name, :string, default: ''
  end
end
