require 'nokogiri'
require 'open-uri'

def get_stations
  get_station Shop.find(483)
end

def get_station(shop)
  # 最寄り駅情報を取得
  url = "http://express.heartrails.com/api/json?method=getStations&x=#{shop.lng.to_f}&y=#{shop.lat.to_f}"
  page = URI.parse(url).open.read
  json = JSON.parse(page)

  stations = json['response']['station']
  stations.each do |station|
    name = station['name']
    prefecture = station['prefecture']
    line = station['line']
    lng = station['x']
    lat = station['y']
    distance = station['distance']
  end
end