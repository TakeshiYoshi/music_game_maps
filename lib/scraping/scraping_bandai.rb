require './lib/scraping/scraping'

def scraping_bandai(game_title)
  # 以下スクレイピング処理
  Prefecture.all.each do |prefecture|
    next if prefecture.id != 1
    start_message(prefecture.name, game_title)
    # 変数初期化
    shops_all = []
    shops = []
    prefecture_id = prefecture.id.to_s.rjust(2, '0')

    # 各ページスクレイピング
    (1..99).each do |n|
      url = "https://www.aikatsu.com/planet/shoplist/list.php?p=#{n}&pref=#{prefecture_id}"
      page = URI.parse(url).open.read
      document = Nokogiri::HTML(page)

      # サーバー負荷軽減のため待機
      sleep $sleep_time

      shops = document.css('.playshopDetailCol')

      # 店舗数0の時の処理
      break if document.css('.noDataCol').present?

      shops.each do |shop|
        name = shop.at_css('td.shop_name').text;
        address = shop.at_css('tr.shop_address span:last-child').text;

        place_id = Shop.find_by(bandai_name: name).place_id if Shop.find_by(bandai_name: name) && Shop.find_by(bandai_name: name).prefecture == Prefecture.find(prefecture.id)

        shop = { name: name,
                 bandai_name: name,
                 address: address,
                 prefecture: prefecture.name,
                 lat: nil,
                 lon: nil,
                 game: game_title,
                 place_id: place_id }
        
        # 緯度経度情報を取得
        if db_shop = Shop.find_by(bandai_name: name)
          shop[:lat] = db_shop.lat.to_f
          shop[:lng] = db_shop.lng.to_f
        end

        # Places APIを用いて店舗データ取得
        shop = get_places_data shop
        puts shop
        output_line
        shops_all << shop if shop.present?
      end
    end

    # 店舗情報の登録と登録した店舗の配列を取得
    registered_shops = register_shop_data shops_all
    # 撤去された店舗の筐体情報を削除
    delete_game_machine(registered_shops, game_title, prefecture.id)
  end
end
