class AddCityToPublishers < ActiveRecord::Migration[5.2]
  def change
    add_column :publishers, :city, :string
  end
end
