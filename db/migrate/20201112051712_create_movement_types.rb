class CreateMovementTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :movement_types do |t|
      t.string :name
      t.string :kind_type
      t.boolean :active

      t.timestamps
    end
  end
end
