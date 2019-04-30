require 'csv'

class BulkInsertList < ApplicationRecord

  validates :EAN13, presence: true

  after_initialize do |bulk_insert_list|
    bulk_insert_list.hash_id = new_hash_id unless bulk_insert_list.hash_id
  end

  def to_param # overridden
    hash_id
  end

  def EAN13=(param)
    if param.is_a? String
      super param
    else
      csv = CSV.read(param.tempfile).flatten.compact.reject(&:empty?)
      csv.delete('ISBN Code')
      csv.delete(' ')
      super csv.join('; ').delete('-')
    end
  end

  def shelf=(param)
    Isbn.where(value: self.EAN13.split('; ')).each do |isbn|
      isbn.book.update(shelf: param)
    end if self.EAN13 && param != 'mixed'
  end

  def shelf
    if self.EAN13
      shelfs = Isbn.where(value: self.EAN13.split('; ')).map do |isbn|
        isbn.book.shelf
      end.uniq

      shelfs.count > 1 ? "mixed" : shelfs.first
    end
  end
end
