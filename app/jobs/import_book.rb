class ImportBook < ProgressJob::Base
  attr_accessor :isbns

  def perform
    require 'scraper'

    update_stage('Initializing')
    scrap = Scraper.new

    update_stage('Importing books...')
    update_progress_max(isbns.count)

    isbns.each do |isbn|
      scrap.from_fantlab isbn unless Isbn.find_by value: isbn
      update_progress
    end

    scrap.quite
  end
end
