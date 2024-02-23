class Work < ApplicationRecord
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :interpreters

  has_and_belongs_to_many :books

  def authors=(names)
    super(names.split('; ').map do |name|
      author = Author.find_by name: name
      author = Author.create(name: name) unless author
      author
    end)
  end

  def interpreters=(names)
    super(names.split('; ').map do |name|
      interpreter = Interpreter.find_by name: name
      interpreter = Interpreter.create(name: name) unless interpreter
      interpreter
    end)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["abstract", "name", "year"]
  end
end
