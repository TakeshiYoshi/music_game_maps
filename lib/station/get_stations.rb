require 'nokogiri'
require 'open-uri'

def get_stations
  Shop.all.each do |shop|
    next if shop.shop_stations.present?

    sleep 0.3
    get_station shop
  end
end

def get_station(shop)
  puts "#{shop.name}の最寄り駅情報を取得する"
  # 最寄り駅情報を取得
  url = "http://express.heartrails.com/api/json?method=getStations&x=#{shop.lng.to_f}&y=#{shop.lat.to_f}"
  page = URI.parse(url).open.read
  json = JSON.parse(page)
  stations_data = json['response']['station']

  # 最寄り駅情報を保存
  stations_data.each do |station_data|
    station_name = station_data['name']
    prefecture = station_data['prefecture']
    line_name = station_data['line']
    lng = station_data['x']
    lat = station_data['y']
    distance = station_data['distance']

    # 路線情報を保存
    line = Line.find_or_create_by(name: line_name)
    # 駅情報を保存
    station = Station.find_or_initialize_by(name: station_name)
    station.update(
      lng: lng,
      lat: lat,
      prefecture: Prefecture.find_by(name: prefecture),
      line: line,
    )
    # 店舗・駅情報を保存
    shop_station = ShopStation.find_or_initialize_by(shop: shop, station: station)
    shop_station.update(distance: distance)
  end
end