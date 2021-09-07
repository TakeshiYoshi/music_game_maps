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

      # 例外処理
      name = 'タイトーステーションイオン札幌平岡店' if name == 'タイトーイオンモール札幌平岡店'
      name = 'セガ龍ヶ崎' if name == 'セガワールド龍ヶ崎'
      name = 'タイトーステーション 佐野新都市店' if name == 'タイトーイオンモール佐野新都市'
      name = 'タイトーFステーションVAL小山店' if name == 'ＴＦＳ　ＶＡＬ小山店'
      name = 'タイトー F ステーション ラザウォーク甲斐双葉店' if name == 'タイトーラザウォーク甲斐双葉店'
      name = 'ハピピランド十日町店' if name == 'Ｈａｐｉｐｉ　Ｌａｎｄ十日町店'
      name = 'タイトーFステーション イオンモール浜松市野店' if name == 'ＴＦＳイオンモール浜松市野店'
      name = 'GAZA3Fゲームコーナー' if name == 'キッズインタイトーＧＡＺＡ店'
      name = 'タイトーFステーション イオン近江八幡店' if name == 'Ｔ／Ｓ　イオン近江八幡店'
      name = 'ゲームセンター GIGA ZONE 広島駅前店' if name == 'ギガゾーン広島駅前店'
      name = 'namcoイオンモール広島府中店' if name == 'ナムコランド広島店'
      name = 'タイトーFステーション モラージュ佐賀店' if name == 'ＴＦＳモラージュ佐賀'
      name = 'namco イオン具志川店' if name == 'ＮＡＭＣＯＬＡＮＤ具志川店'
      next if name == 'あうとばぁん' # 閉店中？

      # デバッグ用
      next if shop['TNAME'] != 'タイトーイオンモール札幌平岡店'

      shop = { name: name,
               address: address,
               prefecture: prefecture.name,
               lat: lat,
               lon: lng,
               game: game_title,
               count: count,
               place_id: nil }

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
