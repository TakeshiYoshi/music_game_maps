require 'open-uri'
require './scraping'

namespace :data_shori do
  desc "配列の処理"
  task test: :environment do
    scraping_konami 'MUSECA'
  end
end
