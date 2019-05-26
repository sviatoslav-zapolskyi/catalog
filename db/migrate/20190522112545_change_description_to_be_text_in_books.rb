class ChangeDescriptionToBeTextInBooks < ActiveRecord::Migration[5.2]
  def change
    change_column :books, :description, :text

    Book.all.each do |b|
      next unless b.isbns.any?
      b.isbns = b.isbns.uniq
      b.save
    end
  end
end
