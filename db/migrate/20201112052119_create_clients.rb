class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :last_name
      t.string :mother_last_name
      t.datetime :birth_date

      t.timestamps
    end
  end
end
