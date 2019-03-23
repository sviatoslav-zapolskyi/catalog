class CreateJoinTableWorksInterpreters < ActiveRecord::Migration[5.2]
  def change
    create_join_table :works, :interpreters do |t|
      # t.index [:work_id, :interpreter_id]
      # t.index [:interpreter_id, :work_id]
    end
  end
end
