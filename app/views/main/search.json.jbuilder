json.books do
  json.array!(@books) do |book|
    json.title book.title
    json.url book_path(book)
  end
end
