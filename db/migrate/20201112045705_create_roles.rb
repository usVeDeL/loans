class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :detail_loan
      t.text :group_loan
      t.text :state
      t.text :movement_type
      t.text :loan
      t.text :movement
      t.text :contact
      t.text :document_type
      t.text :contact_type
      t.text :address
      t.text :client
      t.text :configuration
      t.text :kind_type
      t.text :notification
      t.text :user
      t.text :profile

      t.timestamps
    end
  end
end
