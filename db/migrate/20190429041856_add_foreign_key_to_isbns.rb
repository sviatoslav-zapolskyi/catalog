class AddForeignKeyToIsbns < ActiveRecord::Migration[5.2]
  def change
    change_column :isbns, :book_id, :bigint
    add_foreign_key :isbns, :books, on_delete: :cascade
  end
end
