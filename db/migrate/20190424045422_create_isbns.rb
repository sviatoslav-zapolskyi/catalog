class CreateIsbns < ActiveRecord::Migration[5.2]
  def change
    create_table :isbns do |t|
      t.string :value
      t.integer :book_id

      t.timestamps
    end
  end
end
