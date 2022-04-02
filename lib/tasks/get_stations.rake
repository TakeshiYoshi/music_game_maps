require './lib/station/get_station'

namespace :stations do
  desc "最寄駅情報の取得と駅情報を取得"

  task get_companies: :environment do
    get_companies
  end

  task get_lines: :environment do
    get_lines
  end

  task get_stations: :environment do
    get_stations
  end

  task get_all: :environment do
    get_companies
    get_lines
    get_stations
  end
end
