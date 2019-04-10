class RenameBookYearToBookYearPublished < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :year, :year_published
  end
end
