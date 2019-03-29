json.authors do
  json.array!(@authors) do |author|
    json.name author.name
  end
end
json.interpreters do
  json.array!(@interpreters) do |interpreter|
    json.name interpreter.name
  end
end
