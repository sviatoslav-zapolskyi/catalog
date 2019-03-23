class CreateInterpreters < ActiveRecord::Migration[5.2]
  def change
    create_table :interpreters do |t|
      t.string :name

      t.timestamps
    end
  end
end
