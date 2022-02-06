require './lib/scraping/scraping'
require 'json'

def scraping_taito(game_title)
  # 以下スクレイピング処理
  1.upto(47) do |n|
    # 変数初期化
    shops_all = []
    shops = []

    url = "https://groovecoaster.jp/smt/cache/pref#{n}.json"
    page = URI.parse(url).open.read
    json = JSON.parse(page)
    prefecture = Prefecture.find_by(name: json['DATA'][0]['PREF'])
    start_message(prefecture.name, game_title)
    # サーバー負荷軽減のため待機
    sleep $sleep_time

    # 店舗数0の時の処理
    next if json['DATA'].blank?

    json['DATA'].each do |shop|
      name = shop['TNAME']
      address = format_address(shop['PREF'] + shop['ADDR'])
      lat = shop['LAT']
      lng = shop['LNG']
      count = shop['CNT']

      place_id = Shop.find_by(taito_name: name).place_id if Shop.find_by(taito_name: name)

      shop = { name: name,
               taito_name: name,
               address: address,
               prefecture: prefecture.name,
               lat: lat,
               lon: lng,
               game: game_title,
               count: count,
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
