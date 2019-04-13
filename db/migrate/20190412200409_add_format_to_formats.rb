class AddFormatToFormats < ActiveRecord::Migration[5.2]
  def change
    add_column :formats, :format, :string
  end
end
