require 'isbn'

class DeleteDashesFromBulkInsertsEan13 < ActiveRecord::Migration[5.2]
  def change
    BulkInsertList.find_each do |list|
      isbns = list.EAN13.delete('-').split('; ').map do |ean13|
        ean10 = isbn13_to_isbn10(ean13)

        if ean13.length == 13 && !Isbn.find_by(value: ean13) && Isbn.find_by(value: ean10)
          ean10
        else
          ean13
        end

      end

      list.EAN13 = isbns.join('; ')
      list.save
    end
  end
end
