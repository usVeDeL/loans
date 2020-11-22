class CreateLoanClients < ActiveRecord::Migration[6.0]
  def change
    create_table :loan_clients do |t|
      t.integer :client_id
      t.float :amount
      t.integer :group_id

      t.timestamps
    end
  end
end
