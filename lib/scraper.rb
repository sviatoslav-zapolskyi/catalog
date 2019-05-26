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

  def book_params(fantlab_book_url)
    driver.get fantlab_book_url unless driver.current_url.eql? fantlab_book_url

    {
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
  end

  def book_image_urls(fantlab_book_url)
    driver.get fantlab_book_url unless driver.current_url.eql? fantlab_book_url
    find_elements_by(itemprop: 'image').map { |i| i.attribute('src') }
  end

  def work_urls(fantlab_book_url)
    driver.get fantlab_book_url unless driver.current_url.eql? fantlab_book_url

    driver.find_elements(xpath: "//*[@id='content']//a[contains(@href,'work')]").map do |e|
      href = e.attribute(:href)
      href if href =~ /work\d+$/
    end.compact.uniq
  end

  def work_params(fantlab_work_url)
    driver.get fantlab_work_url

    if any_elements itemprop: 'datePublished'
      date_published_element = find_element_by(itemprop: 'datePublished')
      unit = date_published_element.find_element(xpath: '..').text
      year = date_published_element.text
      major_form = unit.split(", #{year}").first
    end

    {
        name: (find_element_by(itemprop: 'name').text if any_elements itemprop: 'name'),
        major_form: major_form,
        year: year,
        language: (find_element_by(id: 'work-langinit-unit').text.split(': ')[1] if any_elements id: 'work-langinit-unit'),
        authors: driver.find_elements(xpath: "//div[@id='work-names-unit']/*[@itemprop='author']/a").map(&:text).join('; '),
        abstract: (find_element_by(itemprop: 'description').text if any_elements itemprop: 'description'),
    }
  end

  def works(fantlab_book_url)
    work_urls(fantlab_book_url).map do |work_url|
      driver.execute_script 'window.open()'
      driver.switch_to.window driver.window_handles.last

      w_params = work_params(work_url)
      w = Work.find_or_create_by(name: w_params[:name], major_form: w_params[:major_form], abstract: w_params[:abstract], year: w_params[:year], language: w_params[:language])

      driver.close
      driver.switch_to.window( driver.window_handles.first )

      if w.authors.empty?
        w.authors = w_params[:authors]
        w.save
      end

      w
    end
  end

  def duplicate(book)
    Book.where(title: book.title).to_a.each do |found_in_catalog|
      return found_in_catalog if found_in_catalog.works == book.works
      found_in_catalog.isbns.to_a.each do |isbn|
        if book.isbns.to_a.include? isbn
          puts 'duplicate!'
          found_in_catalog.isbns = found_in_catalog.isbns.map(&:value).append(@isbn_value).uniq.join(',')
          return found_in_catalog
        end
      end
    end

    return nil
  end

  def from_fantlab(isbn)
    fantlab_search(isbn).each do |found_book_url|
      b_params = book_params(found_book_url)

      b_params[:isbns] << ", #{@isbn_value}"
      book = Book.new(b_params)

      print " : #{b_params[:title]} ... "

      return if duplicate book

      book_image_urls(found_book_url).each do |url|
        downloaded_image = open(url)
        book.images.attach(io: downloaded_image, filename: "#{url.split('/').last}.jpeg")
      end

      book.works = works(found_book_url)
      book.save

      puts "saved!"
    end
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
    @isbn_value = isbn
    close_all_and_open_new_tab

    print "search #{isbn}"
    driver.get("https://fantlab.ru/searchmain?searchstr=#{isbn}")
    found_books = driver.find_elements(xpath: "//div[@class='one']/table/tbody/tr/td/a")

    if found_books.empty? && isbn.size == 13
      isbn10 = isbn13_to_isbn10 isbn
      print "; #{isbn10}"
      driver.get("https://fantlab.ru/searchmain?searchstr=#{isbn10}")
      found_books = driver.find_elements(xpath: "//div[@class='one']/table/tbody/tr/td/a")

      if found_books.any?
        @isbn_value = isbn10
        BulkInsertList.find_each do |bulk|
          bulk.EAN13.gsub! isbn, isbn10
          bulk.save
        end
      end
    end

    if found_books.any?
      print " #{found_books.size} found."
    else
      puts ' not found!'
      Book.create isbns: isbn, title: 'Не найдено на fantlab', approved: false
    end

    found_books.map { |f| f.attribute(:href) }
  end

end
