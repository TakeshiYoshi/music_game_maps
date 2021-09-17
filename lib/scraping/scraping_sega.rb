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

      # 例外処理
      name = 'ゲームパドックプラスワン' if name == 'GAME PADDOCK＋1'
      name = '五島シティモール' if name == 'ファンタジーランド五島'
      name = 'SOYUGameField熊谷' if name == 'SOYUGameFeild熊谷'
      name = 'ソユーゲームフィールド御所野店' if name == 'SOYUGameField御所野店'
      name = 'ラウンドワンスタジアム 福島店' if name == 'ラウンドワン福島店'
      name = 'レイホウ・スポーツセンター' if name == '嶺宝スポーツセンター'
      name = '（株）インターワールド' if name == 'インターワールド伊勢崎店'
      name = 'ゲームイン・ヒューストン' if name == 'HOUSTON西川口店'
      name = 'ランブルプラザ' if name == '池袋ゲーセンミカドINランブルプラザ'
      name = 'ゲームフィールド イオンタウン弘前樋の口店' if name == 'ゲームフィールド弘前樋の口店'
      name = '万代 多賀城店' if name == 'MS多賀城店'
      name = 'ゆめタウン丸亀 ビッグウェーブ' if name == 'ゆめタウン丸亀 ビック・ウェーブ'
      place_id = 'ChIJSdd9rbHZGGARxCd25n3x7Ic' if name == 'キャッツアイ狭山店'
      place_id = 'ChIJTR-vrwKTGGARzinfEL8pnHA' if name == 'セガ赤羽'
      place_id = 'ChIJh0MWGuXHGGARgjitTf569UI' if name == 'Hapipi Land 東大宮店'
      name = 'レジャラン ビバホーム新習志野' if name == 'スーパービバホーム新習志野店2階'
      next if name == '宮西スタジアム２' # 閉店してる？

      puts name
      # デバッグ用
      # next if node.css('span.store_name').text != '店舗名'

      shop = {  name: name,
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
