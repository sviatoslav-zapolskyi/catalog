class RenameBookDescriprionToBookDescription < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :descriprion, :description
  end
end
