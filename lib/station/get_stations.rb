require 'nokogiri'
require 'open-uri'

def get_stations
  (1..10).each do |n|
    get_station Shop.find(n) if Shop.find(n).present?
  end
end

def get_station(shop)
  # 最寄り駅情報を取得
  url = "http://express.heartrails.com/api/json?method=getStations&x=#{shop.lng.to_f}&y=#{shop.lat.to_f}"
  page = URI.parse(url).open.read
  json = JSON.parse(page)
  stations_data = json['response']['station']
  stations_data.each do |station_data|
    station_name = station_data['name']
    prefecture = station_data['prefecture']
    line_name = station_data['line']
    lng = station_data['x']
    lat = station_data['y']
    distance = station_data['distance']

    line = Line.find_or_create_by(name: line_name)
    station = Station.find_or_create_by(name: station_name) do |s|
      s.lng = lng
      s.lat = lat
      s.prefecture = Prefecture.find_by(name: prefecture)
      s.line = line
    end
  end
end