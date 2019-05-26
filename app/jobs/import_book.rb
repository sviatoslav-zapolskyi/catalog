class ImportBook < ProgressJob::Base
  attr_accessor :isbns

  def perform
    require 'scraper'

    update_stage('Initializing')
    scrap = Scraper.new

    update_stage('Importing books...')
    update_progress_max(isbns.count)

    isbns.each do |isbn|
      update_stage("Importing ISBN: #{isbn}...")
      scrap.from_fantlab isbn
      update_progress
    end

    scrap.quite
  end
end
