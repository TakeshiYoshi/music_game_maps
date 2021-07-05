require './scraping'
require 'json'

def scraping_taito(game_title)
  # 変数初期化
  sleep_time = 10
  # 以下スクレイピング処理
  1.upto(47) do |n|
    # 変数初期化
    shops_all = []
    shops = []
    url = "https://groovecoaster.jp/smt/cache/pref#{n}.json"
    page = URI.parse(url).open.read
    json = JSON.parse(page)
    prefecture = Prefecture.find_by(name: json['DATA'][0]['PREF'])
    prefecture_id = prefecture.id
    puts "#{prefecture.name}で#{game_title}が設置されている店舗のスクレイピングを開始します。"
    # サーバー負荷軽減のため待機
    sleep sleep_time

    json['DATA'].each do |shop|
      shop = { name: format_shop_name(shop['TNAME']),
               address: format_address(shop['PREF'] + shop['ADDR']),
               prefecture_id: prefecture_id,
               operation_time: nil,
               lat: shop['LAT'],
               lon: shop['LNG'],
               game: game_title,
               count: shop['CNT'] }
      shops_all << shop
    end

    shops_all.each do |shop|
      # 既にデータベース登録されているか調べ登録されていれば戻り値で取得する
      registered_shop = check_duplication(shop)

      if registered_shop
        # 既存データの品質が低い場合更新を行う
        update_registered_shop(shop, registered_shop)
        # GameMachineモデル作成(店舗とゲームを関連付けする)
        register_relationship_shop_between_game(registered_shop.name, Game.find_by(title: shop[:game]), shop[:count])
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
  end
end
