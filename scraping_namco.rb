require './scraping'

def scraping_namco(game_title)
  # 変数初期化
  sleep_time = 1

  # 以下スクレイピング処理
  Prefecture.all.each do |prefecture|
    puts "#{prefecture.name}で#{game_title}が設置されている店舗のスクレイピングを開始します。"
    # 変数初期化
    shops_all = []
    shops = []
    prefecture_id = prefecture.id.to_s.rjust(2, '0')

    url = "https://taiko.namco-ch.net/taiko/location/list?area=JP-#{prefecture_id}"
    page = URI.parse(url).open.read
    document = Nokogiri::HTML(page)
    # サーバー負荷軽減のため待機
    sleep sleep_time

    # 店舗数0の時の処理
    if document.css('dl').blank?
      puts '[scraping] 店舗数: 0'
      next
    end

    # 店舗情報取得
    doc_shop_list = document.at_css('dl')
    shop_name_list = doc_shop_list.css('dt').map { |node| format_shop_name node.text }
    shop_detail_link_list = doc_shop_list.css('a').map { |node| "https://taiko.namco-ch.net/taiko/location/#{node[:href][/detail(.*)/]}" }
    shop_address_list = doc_shop_list.css('dd').map { |node| format_address node.text }

    shop_name_list.size.times do |n|
      shop = {  name: shop_name_list[n],
                address: shop_address_list[n],
                prefecture_id: prefecture.id,
                operation_time: nil,
                lat: nil,
                lon: nil,
                game: game_title,
                detail_page_url: shop_detail_link_list[n] }
      shops_all << shop
    end

    shops_all.each do |shop|
      # 店舗詳細ページから営業時間を取得
      get_lat_and_lon(shop)
      # 既にデータベース登録されているか調べ登録されていれば戻り値で取得する
      registered_shop = check_duplication(shop)

      if registered_shop
        # 既存データの品質が低い場合更新を行う
        update_registered_shop(shop, registered_shop)
        # GameMachineモデル作成(店舗とゲームを関連付けする)
        register_relationship_shop_between_game(registered_shop.name, Game.find_by(title: shop[:game]))
      else
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

    puts shops
  end
end
