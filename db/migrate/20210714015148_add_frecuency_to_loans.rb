class AddFrecuencyToLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :payments_number, :integer, null: false, default: 16
    add_column :loans, :frecuency, :string, null: false, default: 'weekly'
  end
end
