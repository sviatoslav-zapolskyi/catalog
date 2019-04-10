class AddTypeToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :type, :string
  end
end
