class Book < ApplicationRecord
  has_many_attached :images

  belongs_to :publisher, optional: true
  belongs_to :serie, optional: true
  belongs_to :language, optional: true
  belongs_to :format, optional: true

  has_and_belongs_to_many :works

  def to_param  # overridden
    hash_id
  end
end
