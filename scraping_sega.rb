require './scraping'

def scraping_sega(game_title)
  # 変数初期化
  sleep_time = 10
  game_code = {
    CHUNITHM: 58,
    maimai: 96,
    WACCA: 93,
    オンゲキ: 88
  }

  # 以下スクレイピング処理
  Prefecture.all.each do |prefecture|
    puts "#{prefecture.name}で#{game_title}が設置されている店舗のスクレイピングを開始します。"
    # 変数初期化
    shops_all = []
    shops = []
    prefecture_id = prefecture.id

    url = "https://location.am-all.net/alm/location?gm=#{game_code[game_title.to_sym]}&ct=1000&at=#{prefecture_id - 1}"
    page = URI.parse(url).open.read
    document = Nokogiri::HTML(page)
    # サーバー負荷軽減のため待機
    sleep sleep_time

    # 店舗数0の時の処理
    if document.css('li').blank?
      puts '[scraping] 店舗数: 0'
      next
    end

    document.css('li').each do |node|
      loc = node.at_css('button.store_bt_google_map')[:onclick]
      reg = /\d{1,3}.\d+/
      lat = loc.scan(reg).first
      lon = loc.scan(reg).last
      shop_details_link = node.at_css('button.bt_details')[:onclick][/shop.*sid=\d*/]
      detail_page_url = "https://location.am-all.net/alm/#{shop_details_link}"

      shop = {  name: format_shop_name(node.css('span.store_name').text),
                address: format_address(node.css('span.store_address').text),
                prefecture_id: prefecture_id,
                operation_time: nil,
                lat: lat,
                lon: lon,
                game: game_title,
                detail_page_url: detail_page_url }
      shops_all << shop
    end

    shops_all.each do |shop|
      # 既にデータベース登録されているか調べ登録されていれば戻り値で取得する
      registered_shop = check_duplication(shop)

      if registered_shop
        # 既存データの品質が低い場合更新を行う
        update_registered_shop(shop, registered_shop)
        # GameMachineモデル作成(店舗とゲームを関連付けする)
        register_relationship_shop_between_game(registered_shop.name, Game.find_by(title: shop[:game]))
      else
        # 店舗詳細ページから営業時間を取得
        get_operation_time(shop)
        # データベース登録用にフォーマットを整える
        shop[:address] = shop[:address][/...??[都道府県](.*)/, 1]
        # データベースに登録するデータを配列に格納
        shops << shop
      end
      output_line
    end

    if shops.present?
      register_shop_data shops
    end
  end
end
