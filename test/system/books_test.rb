require "application_system_test_case"

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = books(:one)
  end

  test "visiting the index" do
    visit books_url
    assert_selector "h1", text: "Books"
  end

  test "creating a Book" do
    visit books_url
    click_on "New Book"

    fill_in "Condition", with: @book.condition
    fill_in "Format", with: @book.format
    fill_in "Hash", with: @book.hash_id
    fill_in "Is new", with: @book.is_new
    fill_in "Isbn", with: @book.isbn
    fill_in "Language", with: @book.language_id
    fill_in "Pages", with: @book.pages
    fill_in "Price", with: @book.price
    fill_in "Publisher", with: @book.publisher_id
    fill_in "Serie", with: @book.serie_id
    fill_in "Shelf", with: @book.shelf
    fill_in "Title", with: @book.title
    fill_in "Volume", with: @book.volume
    fill_in "Volumes", with: @book.volumes
    fill_in "Year Published", with: @book.year_published
    click_on "Create Book"

    assert_text "Book was successfully created"
    click_on "Back"
  end

  test "updating a Book" do
    visit books_url
    click_on "Edit", match: :first

    fill_in "Condition", with: @book.condition
    fill_in "Format", with: @book.format
    fill_in "Hash", with: @book.hash_id
    fill_in "Is new", with: @book.is_new
    fill_in "Isbn", with: @book.isbn
    fill_in "Language", with: @book.language_id
    fill_in "Pages", with: @book.pages
    fill_in "Price", with: @book.price
    fill_in "Publisher", with: @book.publisher_id
    fill_in "Serie", with: @book.serie_id
    fill_in "Shelf", with: @book.shelf
    fill_in "Title", with: @book.title
    fill_in "Volume", with: @book.volume
    fill_in "Volumes", with: @book.volumes
    fill_in "Year Published", with: @book.year_published
    click_on "Update Book"

    assert_text "Book was successfully updated"
    click_on "Back"
  end

  test "destroying a Book" do
    visit books_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Book was successfully destroyed"
  end
end
