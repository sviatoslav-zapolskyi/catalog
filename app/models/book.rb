class Book < ApplicationRecord
  include RansackObject

  has_many_attached :images

  belongs_to :serie, optional: true
  belongs_to :language, optional: true
  belongs_to :format, optional: true

  has_and_belongs_to_many :works
  has_and_belongs_to_many :publishers

  has_many :isbns

  validate :image_type

  after_initialize do |book|
    book.hash_id = new_hash_id unless book.hash_id
  end

  def to_param # overridden
    hash_id
  end

  def publishers=(params)
    publishers = params.map do |p|
      publisher = Publisher.find_by name: p[:name]
      publisher = Publisher.create(p) unless publisher
      publisher
    end
    super(publishers)
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
    format = Format.find_by cover: params[:cover]
    format = Format.create(params) unless format
    super(format)
  end

  def isbns=(values)
    values = values.delete('ISBN').delete(' ').delete('-')
    splitted = values.split(',')
    splitted = values.split(';') if splitted.count == 1

    super(splitted.map do |value|
      isbn = Isbn.find_by value: value
      isbn = Isbn.create(value: value) unless isbn
      isbn
    end)
  end

  private

  def image_type
    images.each do |image|
      errors.add(:image, 'needs to be JPEG or PNG') unless image.content_type.in? %('image/jpeg image/jpg image/png')
    end
  end

end
