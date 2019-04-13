class ApplicationRecord < ActiveRecord::Base
  require 'ransack_object'

  self.abstract_class = true

  def new_hash_id
    begin
      hash_id = SecureRandom.hex(3)
    end while (Book.find_by(hash_id: hash_id) ||
               BulkInsertList.find_by(hash_id: hash_id)
    )
    hash_id
  end
end
