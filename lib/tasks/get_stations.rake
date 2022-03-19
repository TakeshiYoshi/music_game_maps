require './lib/station/get_stations'

namespace :stations do
  desc "最寄駅情報の取得と駅情報を取得"

  task get_stations: :environment do
    get_stations
  end
end
