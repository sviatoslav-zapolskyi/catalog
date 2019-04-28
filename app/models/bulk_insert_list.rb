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
end
