class Author < ApplicationRecord
  has_and_belongs_to_many :works

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
