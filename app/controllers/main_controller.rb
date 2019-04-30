require 'pagy/extras/array'

class MainController < ApplicationController
  def search
    books = Book.ransack(title_cont: params[:q]).result(distinct: :true)
    isbns = Isbn.ransack(value_cont: params[:q]).result(distinct: :true)
    authors = Author.ransack(name_cont: params[:q]).result(distinct: :true)
    publishers = Publisher.ransack(name_cont: params[:q]).result(distinct: :true)
    series = Serie.ransack(name_cont: params[:q]).result(distinct: :true)
    @shelfs = Book.ransack(shelf_cont: params[:q]).result(distinct: :true).map(&:shelf).uniq.first(5)

    respond_to do |format|
      format.html {
        @title = "#{params[:type]}: #{params[:q]}"

        books_by_author = authors.map { |a| a.works.map(&:books) }.flatten
        books_by_publisher =  publishers.map(&:books).flatten
        books_by_serie = series.map(&:books).flatten

        case params[:type]
          when 'author'
            books = books_by_author.uniq
          when 'publisher'
            books = books_by_publisher.uniq
          when 'serie'
            books = books_by_serie.uniq
          when 'shelf'
            books = Book.where(shelf: @shelfs).to_a
          when nil
            @title = "key word: #{params[:q]}"
            books = books.to_a.concat(books_by_author).concat(books_by_publisher).concat(books_by_serie).uniq
        end

        @pagy, @books = pagy_array(books, items: 10)
      }
      format.json {
        @books = books.limit(5)
        @isbns = isbns.limit(5)
        @authors = authors.limit(5)
        @publishers = publishers.limit(5)
        @series = series.limit(5)
      }
    end
  end

  def autocomplete
    case params[:type]
      when 'author'
        respond_to do |format|
          format.json { @authors = Author.ransack(name_cont: params[:q]).result(distinct: :true).limit(5) }
        end
      when 'interpreter'
        respond_to do |format|
          format.json { @interpreters = Interpreter.ransack(name_cont: params[:q]).result(distinct: :true).limit(5) }
        end
      else
        ''
    end
  end

  private

  def pagy_get_items(array, pagy)
    array[pagy.offset, pagy.items]
  end
end
