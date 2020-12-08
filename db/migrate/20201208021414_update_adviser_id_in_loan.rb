class UpdateAdviserIdInLoan < ActiveRecord::Migration[6.0]
  def up
    remove_column :loans, :adviser_id
  end

  def down
    add_column :loans, :adviser_name, :string, default: ''
  end
end
