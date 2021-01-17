class CreateImports < ActiveRecord::Migration[6.1]
  def change
    create_table :imports do |t|
      t.text :file_name
      t.integer :added_items
      t.integer :deleted_items
      t.integer :modified_items
      t.boolean :import_status
      t.boolean :import_mode
      t.text :error_message
      t.references :restaurant, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
