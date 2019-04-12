class RemovePublisherIdFromBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :publisher_id, :integer
  end
end
