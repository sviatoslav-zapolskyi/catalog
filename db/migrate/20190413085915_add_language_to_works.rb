class AddLanguageToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :language, :string
  end
end
