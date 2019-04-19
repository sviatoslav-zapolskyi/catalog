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

  def from_fantlab(ean13)
    fantlab_search(ean13)

    book_params = {
        EAN13: ean13,
        title: driver.find_element(xpath: "//*[@itemprop='name']").text,
        pages: driver.find_element(xpath: "//*[@itemprop='numberOfPages']").text,
        year_published: driver.find_element(xpath: "//*[@itemprop='copyrightYear']").text,
        isbn: driver.find_element(xpath: "//*[@itemprop='isbn']").text,
        circulation: driver.find_element(xpath: "//*[@id='count']").text,
        description: driver.find_element(xpath: "//*[@id='descript']").text,

        publishers: driver.find_elements(xpath: "//*[@itemprop='publisher']/a").map { |p| { name: p.text } },

        format: {
            cover: driver.find_element(xpath: "//*[@itemprop='bookFormat']").text,
        },

        serie: {
            name: driver.find_element(xpath: "//*[@id='series']/a").text
        }
    }

    format_elements = driver.find_elements(xpath: "//*[@id='format']/..")
    book_params[:format][:format] = format_elements.first.text.gsub('Формат: ', '') if format_elements.any?

    book = Book.new(book_params)

    print " : #{book_params[:title]} ... "

    driver.find_elements(xpath: "//*[@itemprop='image']").map { |i| i.attribute('src') }.each do |url|
      downloaded_image = open(url)
      book.images.attach(io: downloaded_image, filename: "#{url.split('/').last}.jpeg")
    end

    driver.find_element(xpath: "//*[@id='content']//a[contains(@href,'work')]").click

    unit = driver.find_element(xpath: "//*[@itemprop='datePublished']/..").text
    year = driver.find_element(xpath: "//*[@itemprop='datePublished']").text
    major_form = unit.split(", #{year}").first

    work_params = {
        name: driver.find_element(xpath: "//*[@itemprop='name']").text,
        major_form: major_form,
        year: year,
        language: driver.find_element(xpath: "//*[@id='work-langinit-unit']").text.split(': ')[1],
        authors: driver.find_elements(xpath: "//div[@id='work-names-unit']/*[@itemprop='author']/a").map(&:text).join('; '),
        abstract: driver.find_element(xpath: "//*[@itemprop='description']").text,
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

  def fantlab_search(ean13)
    print "search #{ean13}"
    driver.get("https://fantlab.ru/searchmain?searchstr=#{ean13}")

    found_books = driver.find_elements(xpath: "//div[@class='one']/table/tbody/tr/td/a")
    if found_books.empty?
      print "; #{isbn13_to_isbn10 ean13}"
      driver.get("https://fantlab.ru/searchmain?searchstr=#{isbn13_to_isbn10 ean13}")
      found_books = driver.find_elements(xpath: "//div[@class='one']/table/tbody/tr/td/a")
    end

    found_books.first.click
  end

end
