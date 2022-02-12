require './lib/scraping/scraping'

def scraping_tetote(game_title)
  # 変数初期化
  shops = []

  url = "https://tetoteconnect.jp/xml/shop_list.xml"
  page = URI.parse(url).open.read
  document = Nokogiri::XML(page)

  nodes = document.xpath("//SHOP")

  nodes.each do |node| 
    prefecture = Prefecture.find_by(name: node.xpath("PREF").text)
    name = node.xpath("NAME").text.gsub(' ', '').gsub('　', ' ')
    address = node.xpath("ADDRESS").text.gsub(' ', '').gsub('　', ' ')
    lat = node.xpath("LATITUDE").text
    lng = node.xpath("LONGITUDE").text

    name = 'ラウンドワンスタジアム 沖縄・宜野湾店' if name == 'ラウンドワン宜野湾店'

    place_id = Shop.find_by(tetote_name: name).place_id if Shop.find_by(tetote_name: name)

    shop = {  name: name,
              tetote_name: name,
              address: address,
              prefecture: prefecture.name,
              lat: lat,
              lon: lng,
              game: game_title,
              place_id: place_id }
    # Places APIを用いてデータを整理する
    shop = get_places_data shop
    puts shop
    output_line
    shops << shop
  end
  puts shops
  # 店舗情報の登録と登録した店舗の配列を取得
  registered_shops = register_shop_data shops
  # 撤去された店舗の筐体情報を削除
  delete_game_machine_tetote(registered_shops, game_title)
end
