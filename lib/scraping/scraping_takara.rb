require './lib/scraping/scraping'

def scraping_takara(game_title)
  # 以下スクレイピング処理
  Prefecture.all.each do |prefecture|
    next if prefecture.id < 39
    start_message(prefecture.name, game_title)
    # 変数初期化
    shops_all = []
    shops = []
    prefecture_id = prefecture.id

    url = "https://cdnprimagiimg01.blob.core.windows.net/primagi/data/json/shop/#{prefecture_id}.json"
    page = URI.parse(url).open.read
    json = JSON.parse(page)

    shops = json.to_h.map do |shop|
      # 半角カタカナを全角へ置換
      shop.last["Address"] = shop.last["Address"].gsub(/[\uFF61-\uFF9F]+/) { |str| str.unicode_normalize(:nfkc) }
      shop.last
    end

    # サーバー負荷軽減のため待機
    sleep $sleep_time

    # 店舗数0の時の処理
    next if shops.blank?

    shops.each do |shop|
      name = shop["Name"]
      address = "#{prefecture.name}#{shop["Address"]}"

      place_id = Shop.find_by(namco_name: name).place_id if Shop.find_by(namco_name: name) && Shop.find_by(namco_name: name).prefecture == Prefecture.find(prefecture.id)

      next if name == "namcoアルプラザ鹿島店"
      next if name == "アミパラ加古川"
      next if name == "namcoニッケパークタウン加古川店"
      next if name == "SOYU Game Field高松"
      next if name == "アミュージアム高松"

      shop = { name: name,
               namco_name: name,
               address: address,
               prefecture: prefecture.name,
               lat: nil,
               lon: nil,
               game: game_title,
               place_id: place_id }
      # 緯度経度情報を取得
      if db_shop = Shop.find_by(namco_name: name)
        shop[:lat] = db_shop.lat.to_f
        shop[:lng] = db_shop.lng.to_f
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
