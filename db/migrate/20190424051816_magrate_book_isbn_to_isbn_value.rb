class MagrateBookIsbnToIsbnValue < ActiveRecord::Migration[5.2]
  def change
    Book.find_each do |book|
      next unless book.isbn.is_a? String
      isbns = book.isbn.delete(' ').delete('-').split(',')

      isbns.each do |isbn|
        book.isbns << Isbn.find_or_create_by(value: isbn)
      end

      book.save
    end
  end
end
