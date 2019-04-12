class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :delete_image_attachment]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
    @book.works << Work.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    @book.works << update_works

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    update_works
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_image_attachment
    @image = ActiveStorage::Attachment.find(params[:format])
    @image.purge
    redirect_back(fallback_location: request.referer)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find_by hash_id: params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:title, :pages, :year_published, { format: [:cover] }, :isbn, :volume, :volumes, :price, :is_new, :condition, { publishers: [:name] }, { serie: [:name] }, { language: [:name] }, :shelf, { images: [] }, :circulation, :description, :quantity)
  end

  def works_params
    params.require(:book).permit({ works: [:id, :name, :authors, :interpreters] })[:works]
  end

  def update_works
    works_params.map do |params|
      if params[:id].empty?
        Work.create params
      else
        work = Work.find(params[:id])
        work.update(params)
        work
      end
    end
  end
end
