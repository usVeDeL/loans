class CreateClientContactTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :client_contact_types do |t|
      t.string :details
      t.integer :client_id
      t.integer :contact_type_id

      t.timestamps
    end
  end
end
