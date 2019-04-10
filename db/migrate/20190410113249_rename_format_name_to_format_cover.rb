class RenameFormatNameToFormatCover < ActiveRecord::Migration[5.2]
  def change
    rename_column :formats, :name, :cover
  end
end
