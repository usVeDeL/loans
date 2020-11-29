class AddAddressContractLoanLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :address_contract, :string
  end
end
