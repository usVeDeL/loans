class CreateDocumentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :document_types do |t|
      t.string :name
      t.boolean :active
      t.boolean :required

      t.timestamps
    end
  end
end
