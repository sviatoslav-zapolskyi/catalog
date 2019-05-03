class CreateJoinTableBooksIsbns < ActiveRecord::Migration[5.2]
  def change
    create_join_table :books, :isbns do |t|
      t.index [:book_id, :isbn_id]
      t.index [:isbn_id, :book_id]
    end

    Isbn.all.each do |isbn|
      if isbn.book_id
        execute "insert into books_isbns (book_id, isbn_id) values (#{isbn.book_id}, #{isbn.id})"
        isbn.value= to_isbn(isbn.value)
        isbn.save
      else
        isbn.destroy
      end
    end

    remove_foreign_key :isbns, :books
    remove_column :isbns, :book_id, :bigint
  end

  private

  def to_isbn(value)
    value.match(/([\d]{9}(\d|X)([\d]{3})?)/).captures.first
  rescue
    value
  end
end
