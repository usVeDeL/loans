class CreateClientAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :client_addresses do |t|
      t.string :state_name
      t.string :town
      t.string :neighborhood
      t.string :code_zip
      t.string :street
      t.string :number_exterior
      t.string :number_interior
      t.integer :client_id

      t.timestamps
    end
  end
end
