class AddLoanIdToLoanClients < ActiveRecord::Migration[6.0]
  def change
    add_column :loan_clients, :loan_id, :integer
  end
end
