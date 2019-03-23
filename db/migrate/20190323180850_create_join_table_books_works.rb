class CreateJoinTableBooksWorks < ActiveRecord::Migration[5.2]
  def change
    create_join_table :books, :works do |t|
      # t.index [:book_id, :work_id]
      # t.index [:work_id, :book_id]
    end
  end
end
