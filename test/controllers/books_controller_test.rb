require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
  end

  test "should get index" do
    get books_url
    assert_response :success
  end

  test "should get new" do
    get new_book_url
    assert_response :success
  end

  test "should create book" do
    assert_difference('Book.count') do
      post books_url, params: { book: { condition: @book.condition, format: @book.format, hash_id: @book.hash_id, is_new: @book.is_new, isbn: @book.isbn, language_id: @book.language_id, pages: @book.pages, price: @book.price, publisher_id: @book.publisher_id, serie_id: @book.serie_id, shelf: @book.shelf, title: @book.title, volume: @book.volume, volumes: @book.volumes, year: @book.year } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test "should show book" do
    get book_url(@book)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_url(@book)
    assert_response :success
  end

  test "should update book" do
    patch book_url(@book), params: { book: { condition: @book.condition, format: @book.format, hash_id: @book.hash_id, is_new: @book.is_new, isbn: @book.isbn, language_id: @book.language_id, pages: @book.pages, price: @book.price, publisher_id: @book.publisher_id, serie_id: @book.serie_id, shelf: @book.shelf, title: @book.title, volume: @book.volume, volumes: @book.volumes, year: @book.year } }
    assert_redirected_to book_url(@book)
  end

  test "should destroy book" do
    assert_difference('Book.count', -1) do
      delete book_url(@book)
    end

    assert_redirected_to books_url
  end
end
