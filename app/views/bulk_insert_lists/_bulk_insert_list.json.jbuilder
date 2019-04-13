json.extract! bulk_insert_list, :id, :hash_id, :EAN13, :created_at, :updated_at
json.url bulk_insert_list_url(bulk_insert_list, format: :json)
