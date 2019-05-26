class RemoveWorkDublicates < ActiveRecord::Migration[5.2]
  def change
    Work.all.group_by { |w| [ w.name, w.major_form, w.abstract, w.year, w.language ] }.values.each do |duplicates|
      first = duplicates.shift
      first.books << duplicates.map(&:books)
      first.save
      duplicates.each(&:destroy)
    end
  end
end
