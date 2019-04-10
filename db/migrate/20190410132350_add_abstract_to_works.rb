class AddAbstractToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :abstract, :string
  end
end
