class Book < ApplicationRecord
  include RansackObject

  has_many_attached :images

  belongs_to :publisher, optional: true
  belongs_to :serie, optional: true
  belongs_to :language, optional: true
  belongs_to :format, optional: true

  has_and_belongs_to_many :works

  def to_param # overridden
    hash_id
  end

  def publisher=(params)
    publisher = Publisher.find_by name: params[:name]
    publisher = Publisher.create(params) unless publisher
    super(publisher)
  end

  def serie=(params)
    serie = Serie.find_by name: params[:name]
    serie = Serie.create(params) unless serie
    super(serie)
  end

  def language=(params)
    language = Language.find_by name: params[:name]
    language = Language.create(params) unless language
    super(language)
  end

  def format=(params)
    format = Format.find_by name: params[:name]
    format = Format.create(params) unless format
    super(format)
  end

  attr_accessor :form_works
end
