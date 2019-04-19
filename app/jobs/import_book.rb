class ImportBook < ProgressJob::Base
  attr_accessor :ean13s

  def perform
    require 'scraper'

    update_stage('Initializing')
    scrap = Scraper.new

    update_stage('Importing books...')
    update_progress_max(ean13s.count)

    ean13s.each do |ean13|
      scrap.from_fantlab ean13 unless Book.find_by(EAN13: ean13)
      update_progress
    end

    scrap.quite
  end
end
