class AddCirculationToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :circulation, :string
  end
end
