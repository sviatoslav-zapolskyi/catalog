class AddCountryToPublishers < ActiveRecord::Migration[5.2]
  def change
    add_column :publishers, :country, :string
  end
end
