require 'selenium-webdriver'
require 'open-uri'

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
        title: (find_element_by(itemprop: 'name').text if any_elements itemprop: 'name'),
        pages: (find_element_by(itemprop: 'numberOfPages').text if any_elements itemprop: 'numberOfPages'),
        year_published: (find_element_by(itemprop: 'copyrightYear').text if any_elements itemprop: 'copyrightYear'),
        isbns: (find_element_by(itemprop: 'isbn').text if any_elements itemprop: 'isbn'),
        circulation: (find_element_by(id: 'count').text if any_elements id: 'count'),
        description: (find_element_by(id: 'descript').text if any_elements id: 'descript'),

        publishers: find_elements_by(itemprop: 'publisher').map { |p| { name: p.text } },

        format: {
            cover: (find_element_by(itemprop: 'bookFormat').text if any_elements itemprop: 'bookFormat'),
            format: (find_element_by(id: 'format').find_element(xpath: '..').text.gsub('Формат: ', '') if any_elements id: 'format')
        },

        serie: {
            name: (find_element_by(id: 'series').text if any_elements id: 'series'),
        },

        approved: false
    }

    book = Book.new(book_params)

    print " : #{book_params[:title]} ... "

    if Isbn.where(value: book.isbns.map(&:value)).any?
      puts 'duplicate!'
      return
    end

    find_elements_by(itemprop: 'image').map { |i| i.attribute('src') }.each do |url|
      downloaded_image = open(url)
      book.images.attach(io: downloaded_image, filename: "#{url.split('/').last}.jpeg")
    end

    driver.find_elements(xpath: "//*[@id='content']//a[contains(@href,'work')]").map do |e|
      href = e.attribute(:href)
      href if href =~ /work\d+$/
    end.compact.uniq.each do |work_link|
      driver.execute_script 'window.open()'
      driver.switch_to.window driver.window_handles.last
      driver.get work_link

      if any_elements itemprop: 'datePublished'
        date_published_element = find_element_by(itemprop: 'datePublished')
        unit = date_published_element.find_element(xpath: '..').text
        year = date_published_element.text
        major_form = unit.split(", #{year}").first
      end

      work_params = {
          name: (find_element_by(itemprop: 'name').text if any_elements itemprop: 'name'),
          major_form: major_form,
          year: year,
          language: (find_element_by(id: 'work-langinit-unit').text.split(': ')[1] if any_elements id: 'work-langinit-unit'),
          authors: driver.find_elements(xpath: "//div[@id='work-names-unit']/*[@itemprop='author']/a").map(&:text).join('; '),
          abstract: (find_element_by(itemprop: 'description').text if any_elements itemprop: 'description'),
      }

      work = Work.new(work_params)
      work.save

      book.works << work

      driver.close
      driver.switch_to.window( driver.window_handles.first )
    end

    book.save

    puts "saved!"

  end

  def quite
    puts "Selenium WebDriver Destroy"
    @driver.quit
  end

  private

  def close_all_and_open_new_tab
    driver.execute_script 'window.open()'

    while driver.window_handles.count > 1
      driver.switch_to.window( driver.window_handles.first )
      driver.close
    end

    driver.switch_to.window( driver.window_handles.first )
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
    close_all_and_open_new_tab

    print "search #{isbn}"
    driver.get("https://fantlab.ru/searchmain?searchstr=#{isbn}")
    found_books = driver.find_elements(xpath: "//div[@class='one']/table/tbody/tr/td/a")

    if found_books.empty? && isbn.size == 13
      isbn10 = isbn13_to_isbn10 isbn
      print "; #{isbn10}"
      driver.get("https://fantlab.ru/searchmain?searchstr=#{isbn10}")
      found_books = driver.find_elements(xpath: "//div[@class='one']/table/tbody/tr/td/a")

      BulkInsertList.find_each do |bulk|
        bulk.EAN13.gsub! isbn, isbn10
        bulk.save
      end if found_books.any?
    end

    if found_books.any?
      print " found."
      found_books.first.click
      true
    else
      puts ' not found!'
      Book.create isbns: isbn, title: 'Не найдено на fantlab', approved: false
      false
    end

  end

end
