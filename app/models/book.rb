class Book < ApplicationRecord
  has_many_attached :images

  belongs_to :publisher, optional: true
  belongs_to :serie, optional: true
  belongs_to :language, optional: true
  belongs_to :format, optional: true

  has_and_belongs_to_many :works

  def to_param # overridden
    hash_id
  end

  def publisher=(value)
    publisher = Publisher.find_by name: value
    publisher = Publisher.create(name: value) unless publisher
    super(publisher)
  end

  def serie=(value)
    serie = Serie.find_by name: value
    serie = Serie.create(name: value) unless serie
    super(serie)
  end

  def language=(value)
    language = Language.find_by name: value
    language = Language.create(name: value) unless language
    super(language)
  end

  def format=(value)
    format = Format.find_by name: value
    format = Format.create(name: value) unless format
    super(format)
  end

  attr_accessor :form_works
end
