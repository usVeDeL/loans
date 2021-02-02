class AddStatusToLoan < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :status, :string
  end
end
