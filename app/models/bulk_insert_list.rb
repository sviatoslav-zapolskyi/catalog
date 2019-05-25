require 'csv'

class BulkInsertList < ApplicationRecord

  S = '; '.freeze

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
      csv = CSV.read(param.tempfile).flatten.compact.map do |s|
        s.delete('-') if s.is_a? String
      end.reject do |s|
        s.empty? || s.eql?('ISBN Code') || s.eql?(' ') || ![10, 13].include?(s.length)
      end

      super csv.join S
    end
  end

  def shelf=(param)
    Isbn.where(value: self.EAN13.split(S)).each do |isbn|
      isbn.book.update(shelf: param)
    end if self.EAN13 && param != 'mixed'
  end

  def shelf
    if self.EAN13
      shelfs = Isbn.where(value: self.EAN13.split(S)).map do |isbn|
        isbn.book.map(&:shelf)
      end.flatten.uniq

      shelfs.count > 1 ? "mixed" : shelfs.first
    end
  end

  def isbns
    self.EAN13.split S
  end
end
