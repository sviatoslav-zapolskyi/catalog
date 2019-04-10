class AddDescriprionToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :descriprion, :string
  end
end
