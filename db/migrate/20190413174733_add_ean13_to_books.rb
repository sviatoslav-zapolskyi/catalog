class AddEan13ToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :EAN13, :string
  end
end
