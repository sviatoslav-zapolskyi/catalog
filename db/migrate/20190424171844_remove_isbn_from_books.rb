class RemoveIsbnFromBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :isbn, :string
  end
end
