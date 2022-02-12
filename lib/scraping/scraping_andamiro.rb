require './lib/scraping/scraping'
require 'json'

def scraping_andamiro(game_title)
  # 以下スクレイピング処理
  1.upto(47) do |n|
    puts '----------------------------'
    # 変数初期化
    shops_all = []
    shops = []

    url = "https://chrono-circle.com/page/location.php?lat=0&lon=^&region=#{n}&name="
    page = URI.parse(url).open.read
    document = Nokogiri::HTML(page)

    # 都道府県取得
    pref_name = document.at_css('option[selected]')&.text
    prefecture = Prefecture.find_by(name: pref_name) if pref_name && pref_name != '-'
    start_message(prefecture.name, game_title) if pref_name && pref_name != '-'
    # サーバー負荷軽減のため待機
    sleep $sleep_time

    tr_list = document.css('table.board_st > tbody > tr')

    # 店舗数0の時の処理
    next if tr_list.css('td[colspan="3"]').text == 'No Data.'

    tr_list.drop(1).each do |node|
      name = "ラウンドワン #{node.at_css('td:nth-child(1)').text}" # 現状ラウンドワンのみ設置のため
      address = node.at_css('td:nth-child(2)').text
      lat = node['onclick'].scan(/\d{1,3}.\d{1,4}/).first
      lng = node['onclick'].scan(/\d{1,3}.\d{1,4}/).last

      place_id = Shop.find_by(andamiro_name: name).place_id if Shop.find_by(andamiro_name: name)

      shop = {  name: name,
                andamiro_name: name,
                address: address,
                prefecture: prefecture.name,
                lat: lat,
                lon: lng,
                game: game_title,
                place_id: place_id }
      # Places APIを用いてデータを整理する
      shop = get_places_data shop
      puts shop
      output_line
      shops << shop
    end
    puts shops
    # 店舗情報の登録と登録した店舗の配列を取得
    registered_shops = register_shop_data shops
    # 撤去された店舗の筐体情報を削除
    delete_game_machine(registered_shops, game_title, prefecture.id)
  end
end
