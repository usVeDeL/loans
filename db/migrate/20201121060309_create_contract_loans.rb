class CreateContractLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :contract_loans do |t|
      t.integer :loan_id
      t.integer :contract_id

      t.timestamps
    end
  end
end
