class RemoveEan13FromBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :ean13, :string
  end
end
