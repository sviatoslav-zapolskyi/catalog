class Isbn < ApplicationRecord
  has_and_belongs_to_many :book

  def self.ransackable_attributes(auth_object = nil)
    ["value"]
  end
end
