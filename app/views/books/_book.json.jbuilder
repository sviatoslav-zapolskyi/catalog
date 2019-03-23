json.extract! book, :id, :hash_id, :title, :pages, :year, :format, :isbn, :volume, :volumes, :price, :is_new, :condition, :publisher_id, :serie_id, :language_id, :shelf, :created_at, :updated_at
json.url book_url(book, format: :json)
