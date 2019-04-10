class AddYearToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :year, :integer
  end
end
