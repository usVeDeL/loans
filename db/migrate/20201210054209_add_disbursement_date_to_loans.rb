class AddDisbursementDateToLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :disbursement_date, :datetime, default: DateTime.now
  end
end
