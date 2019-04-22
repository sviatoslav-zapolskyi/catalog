class ReplaceBookApprovedNullWithFalse < ActiveRecord::Migration[5.2]
  def change
    Book.where(approved: nil).each do |book|
      book.approved = false
      book.save
    end
  end
end
