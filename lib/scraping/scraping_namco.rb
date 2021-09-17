require './lib/scraping/scraping'

def scraping_namco(game_title)
  # 以下スクレイピング処理
  Prefecture.all.each do |prefecture|
    next if prefecture.id < 23
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

      # 例外処理
      name = 'ギャラクシーゲート 星が浦' if name == 'GALAXY GATE 星が浦'
      name = 'キッズパーク イオン岩見沢店' if name == 'キッズパーク イオン岩見沢'
      name = 'MS仙台南店' if name == 'MS仙台南'
      name = '万代 多賀城店' if name == 'MS多賀城'
      name = 'Be-come 成沢店' if name == 'ビーカム成沢'
      name = 'フタバ図書 ソフトピア八本松店' if name == 'GIGA八本松'
      name = 'スポガ久留米 ボウリング' if name == 'バナナパーティー久留米'
      name = 'G-Stage 浜町店' if name == 'G-stage浜の町'
      name = 'ゆめタウン丸亀 ビッグウェーブ' if name == 'BIG WAVE ゆめタウン丸亀'
      name = 'アル・プラザ加賀' if name == 'ゲームパークMECHA加賀'
      name = '豊崎ライフスタイルセンター TOMITON' if name == 'ゲームランドジョイジャングルinとみとん'
      name = '第2鬼頭マンション' if name == 'チャレンジランド1号'
      place_id = 'ChIJTR-vrwKTGGARzinfEL8pnHA' if name == 'セガ赤羽'
      place_id = 'ChIJh0MWGuXHGGARgjitTf569UI' if name == 'HapipiLand東大宮'
      place_id = 'ChIJ_W8XoQUT5TQRG8vPiBMM9fA' if name == 'ジョイジャングル美浜'
      next if name == 'HapipiLand阿見' # 閉店

      # デバッグ用
      # next if shop_name_list[n].text != '店舗名'

      shop = { name: name,
               address: address,
               prefecture: prefecture.name,
               lat: nil,
               lon: nil,
               game: game_title,
               detail_page_url: shop_detail_link_list[n],
               place_id: place_id }
      # 緯度経度情報を取得
      shop = get_lat_and_lon shop
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
