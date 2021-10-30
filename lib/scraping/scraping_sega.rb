require './lib/scraping/scraping'

def scraping_sega(game_title)
  game_code = {
    CHUNITHM: 58,
    maimai: 96,
    WACCA: 93,
    オンゲキ: 88
  }

  # 以下スクレイピング処理
  Prefecture.all.each do |prefecture|
    start_message(prefecture.name, game_title)
    # 変数初期化
    shops_all = []
    shops = []
    prefecture_id = prefecture.id

    url = "https://location.am-all.net/alm/location?gm=#{game_code[game_title.to_sym]}&ct=1000&at=#{prefecture_id - 1}"
    page = URI.parse(url).open.read
    document = Nokogiri::HTML(page)
    # サーバー負荷軽減のため待機
    sleep $sleep_time

    # 店舗数0の時の処理
    next if document.css('li').blank?

    document.css('li').each do |node|
      loc = node.at_css('button.store_bt_google_map')[:onclick]
      reg = /\d{1,3}.\d+/
      lat = loc.scan(reg).first
      lon = loc.scan(reg).last
      shop_details_link = node.at_css('button.bt_details')[:onclick][/shop.*sid=\d*/]
      name = node.css('span.store_name').text.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z').gsub('．', '.').gsub('　', ' ')

      place_id = Shop.find_by(sega_name: name).place_id if Shop.find_by(sega_name: name)

      shop = {  name: name,
                sega_name: name,
                address: format_address(node.css('span.store_address').text),
                prefecture: prefecture.name,
                lat: lat,
                lon: lon,
                game: game_title,
                place_id: place_id }

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
