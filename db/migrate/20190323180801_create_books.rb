class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :hash_id
      t.string :title
      t.integer :pages
      t.integer :year
      t.integer :format
      t.string :isbn
      t.integer :volume
      t.integer :volumes
      t.string :price
      t.boolean :is_new
      t.integer :condition
      t.integer :publisher_id
      t.integer :serie_id
      t.integer :language_id
      t.string :shelf

      t.timestamps
    end
    add_index :books, :hash_id
  end
end
