class Serie < ApplicationRecord
  has_many :books

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
