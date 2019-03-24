class Work < ApplicationRecord
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :interpreters

  has_and_belongs_to_many :books
end
