require './lib/scraping/scraping'

def scraping_namco(game_title)
  # 以下スクレイピング処理
  Prefecture.all.each do |prefecture|
    start_message(prefecture.name, game_title)
    # 変数初期化
    shops_all = []
    shops = []
    prefecture_id = prefecture.id.to_s.rjust(2, '0')

    url = "https://taiko.namco-ch.net/taiko/location/list?area=JP-#{prefecture_id}"
    page = URI.parse(url).open.read
    document = Nokogiri::HTML(page)
    # サーバー負荷軽減のため待機
    sleep $sleep_time

    # 店舗数0の時の処理
    next if document.css('dl').blank?

    # 店舗情報取得
    doc_shop_list = document.at_css('dl')
    shop_name_list = doc_shop_list.css('dt')
    shop_detail_link_list = doc_shop_list.css('a').map { |node| "https://taiko.namco-ch.net/taiko/location/#{node[:href][/detail(.*)/]}" }
    shop_address_list = doc_shop_list.css('dd').map { |node| node.text.gsub(' ', '').gsub('　', ' ') }

    shop_name_list.size.times do |n|
      name = shop_name_list[n].text
      address = shop_address_list[n]

      place_id = Shop.find_by(namco_name: name).place_id if Shop.find_by(namco_name: name) && Shop.find_by(namco_name: name).prefecture == Prefecture.find(prefecture.id)

      shop = { name: name,
               namco_name: name,
               address: address,
               prefecture: prefecture.name,
               lat: nil,
               lon: nil,
               game: game_title,
               detail_page_url: shop_detail_link_list[n],
               place_id: place_id }
      # 緯度経度情報を取得
      if db_shop = Shop.find_by(namco_name: name)
        shop[:lat] = db_shop.lat.to_f
        shop[:lng] = db_shop.lng.to_f
      else
        shop = get_lat_and_lon shop
      end
      # Places APIを用いて店舗データ取得
      shop = get_places_data shop
      puts shop
      output_line
      shops_all << shop if shop.present?
    end

    # 店舗情報の登録と登録した店舗の配列を取得
    registered_shops = register_shop_data shops_all
    # 撤去された店舗の筐体情報を削除
    delete_game_machine(registered_shops, game_title, prefecture.id)
  end
end
