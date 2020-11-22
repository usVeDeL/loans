class CreatePersonalDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :personal_documents do |t|
      t.integer :client_id
      t.integer :document_type_id
      t.string :document

      t.timestamps
    end
  end
end
