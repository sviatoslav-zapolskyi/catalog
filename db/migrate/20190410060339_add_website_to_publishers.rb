class AddWebsiteToPublishers < ActiveRecord::Migration[5.2]
  def change
    add_column :publishers, :website, :string
  end
end
