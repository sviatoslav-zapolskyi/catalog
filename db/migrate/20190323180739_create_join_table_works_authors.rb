class CreateJoinTableWorksAuthors < ActiveRecord::Migration[5.2]
  def change
    create_join_table :works, :authors do |t|
      # t.index [:work_id, :author_id]
      # t.index [:author_id, :work_id]
    end
  end
end
