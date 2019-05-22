json.books do
  json.array!(@books) do |book|
    json.name book.title
    json.url book_path(book)
  end
end

json.isbns do
  json.array!(@isbns) do |isbn|
    json.name isbn.value
    json.url search_path(type: 'isbn', q: isbn.value)
  end
end

json.authors do
  json.array!(@authors) do |author|
    json.name author.name
    json.url search_path(type: 'author', q: author.name)
  end
end

json.putlishers do
  json.array!(@publishers) do |publisher|
    json.name publisher.name
    json.url search_path(type: 'publisher', q: publisher.name)
  end
end

json.series do
  json.array!(@series) do |serie|
    json.name serie.name
    json.url search_path(type: 'serie', q: serie.name)
  end
end

json.shelfs do
  json.array!(@shelfs) do |shelf|
    json.name shelf
    json.url search_path(type: 'shelf', q: shelf)
  end
end
