class RenameWorkTitleToWorkName < ActiveRecord::Migration[5.2]
  def change
    rename_column :works, :title, :name
  end
end
