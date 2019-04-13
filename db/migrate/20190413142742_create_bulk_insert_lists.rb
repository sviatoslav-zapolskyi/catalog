class CreateBulkInsertLists < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_insert_lists do |t|
      t.string :hash_id
      t.text :EAN13

      t.timestamps
    end
    add_index :bulk_insert_lists, :hash_id
  end
end
