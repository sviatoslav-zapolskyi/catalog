class MainController < ApplicationController
  def search
    @books = Book.ransack(title_cont: params[:q]).result(distinct: :true)

    respond_to do |format|
      format.html {}
      format.json {
        @books = @books.limit(5)
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
end
