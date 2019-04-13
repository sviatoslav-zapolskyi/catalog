class RenameWorkTypeToWorkMajorForm < ActiveRecord::Migration[5.2]
  def change
    rename_column :works, :type, :major_form
  end
end
