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
end
