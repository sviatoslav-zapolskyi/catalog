class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :format, :format_id
  end
end
