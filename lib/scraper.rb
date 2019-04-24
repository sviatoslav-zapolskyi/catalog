require 'selenium-webdriver'
require 'open-uri'
require 'csv'

require_relative 'isbn'

class Scraper

  attr_accessor :driver

  def initialize
    puts "Selenium::WebDriver Init"
    options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
    @driver = Selenium::WebDriver.for(:firefox, options: options)
    @driver.manage.timeouts.implicit_wait = 3
  end

  def from_fantlab(isbn)
    return unless fantlab_search(isbn)

    book_params = {
        EAN13: isbn,
        title: element(itemprop: 'name').text,
        pages: element(itemprop: 'numberOfPages').text,
        year_published: element(itemprop: 'copyrightYear').text,
        isbn: element(itemprop: 'isbn').text,
        circulation: element(id: 'count').text,
        description: element(id: 'descript').text,

        publishers: find_elements_by(itemprop: 'publisher').map { |p| { name: p.text } },

        format: {
            cover: element(itemprop: 'bookFormat').text,
        },

        serie: {
            name: element(id: 'series').text
        }
    }

    format_element = element(id: 'format')
    book_params[:format][:format] = format_element.find_element(xpath: '..').text.gsub('Формат: ', '') if format_element

    book = Book.new(book_params)

    print " : #{book_params[:title]} ... "

    find_elements_by(itemprop: 'image').map { |i| i.attribute('src') }.each do |url|
      downloaded_image = open(url)
      book.images.attach(io: downloaded_image, filename: "#{url.split('/').last}.jpeg")
    end

    driver.find_element(xpath: "//*[@id='content']//a[contains(@href,'work')]").click

    if any_elements itemprop: 'datePublished'
      date_published_element = find_element_by(itemprop: 'datePublished')
      unit = date_published_element.find_element(xpath: '..').text
      year = date_published_element.text
      major_form = unit.split(", #{year}").first
    end

    work_params = {
        name: element(itemprop: 'name').text,
        major_form: major_form,
        year: year,
        language: element(id: 'work-langinit-unit').text.split(': ')[1],
        authors: driver.find_elements(xpath: "//div[@id='work-names-unit']/*[@itemprop='author']/a").map(&:text).join('; '),
        abstract: element(itemprop: 'description').text,
    }

    work = Work.new(work_params)
    work.save

    book.works << work
    book.save

    puts "saved!"

  end

  def quite
    puts "Selenium WebDriver Destroy"
    @driver.quit
  end

  private

  def element(param)
    any_elements(param) ? find_element_by(param) : nil
  end

  def any_elements(param)
    find_elements_by(param).any?
  end

  def find_element_by(param)
    driver.find_element(xpath: to_xpath(param))
  end

  def find_elements_by(param)
    driver.find_elements(xpath: to_xpath(param))
  end

  def to_xpath(param)
    raise "to_xpath requires only one key but receive param with multi key: #{param}" if param.keys.count > 1

    attribute = param.keys.first
    value = param[attribute]

    "//*[@#{attribute.to_s}='#{value}']"
  end

  def fantlab_search(isbn)
    print "search #{isbn}"
    driver.get("https://fantlab.ru/searchmain?searchstr=#{isbn}")
    found_books = driver.find_elements(xpath: "//div[@class='one']/table/tbody/tr/td/a")

    if found_books.empty? && isbn.size == 13
      isbn10 = isbn13_to_isbn10 isbn
      print "; #{isbn10}"
      driver.get("https://fantlab.ru/searchmain?searchstr=#{isbn10}")
      found_books = driver.find_elements(xpath: "//div[@class='one']/table/tbody/tr/td/a")
    end

    if found_books.any?
      print " found."
      found_books.first.click
      true
    else
      puts ' not found!'
      Book.create EAN13: isbn, isbn: isbn, title: 'Не найдено на fantlab'
      false
    end

  end

end
