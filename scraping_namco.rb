require './scraping'

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

      # 例外処理
      name = 'ギャラクシーゲート 星が浦' if name == 'GALAXY GATE 星が浦'
      name = 'キッズパーク イオン岩見沢店' if name == 'キッズパーク イオン岩見沢'
      name = 'MS仙台南店' if name == 'MS仙台南'
      name = '万代 多賀城店' if name == 'MS多賀城'
      name = 'Be-come 成沢店' if name == 'ビーカム成沢'
      name = 'フタバ図書 ソフトピア八本松店' if name == 'GIGA八本松'
      name = 'スポガ久留米 ボウリング' if name == 'バナナパーティー久留米'
      name = 'G-Stage 浜町店' if name == 'G-stage浜の町'
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
               place_id: nil }
      # 緯度経度情報を取得
      shop = get_lat_and_lon shop
      # Places APIを用いて店舗データ取得
      shop = get_places_data shop
      puts shop
      output_line
      shops_all << shop if shop.present?
    end

    # 以下DB登録処理
    shops = get_need_to_register_shops(shops_all)
    register_shop_data shops if shops.present?
  end
end
