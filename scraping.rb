require 'nokogiri'
require 'open-uri'

# スクレイピングする際の待機時間
$sleep_time = 10

def register_shop_data(shops)
  # Qiita記事参考: https://qiita.com/zakuroishikuro/items/066421bce820e3c73ce9
  city_reg = /((?:旭川|伊達|石狩|盛岡|奥州|田村|南相馬|那須塩原|東村山|武蔵村山|羽村|十日町|上越|富山|野々市|大町|蒲郡|四日市|姫路|大和郡山|廿日市|下松|岩国|田川|大村)市|.+?郡(?:玉村|大町|.+?)[町村]|.+?[市区町村])/
  shops.each do |shop|
    puts shop
    name = shop[:name]
    address = shop[:address]
    prefecture = Prefecture.find_by(name: shop[:prefecture])
    # addressから市区町村を抽出
    city = address[/...??[都道府県](.*)/, 1].match(city_reg).to_s
    # 例外処理
    city = city.gsub('山口市小郡前田町', '山口市') if city == '山口市小郡前田町'
    city = city.gsub('篠山市', '丹波篠山市') if city == '篠山市'
    # 「〜郡」を除去
    city = city.split('郡').last if city.include?('余市') || city.include?('富谷') || !city.include?('市')
    # cityモデルを格納
    city = prefecture.cities.find_by(name: city)
    # ゲームモデル取得
    game = Game.find_by(title: shop[:game])

    # デバッグ用ログ出力
    puts name
    puts address
    puts prefecture.name
    puts city.name

    puts "\n*** 店舗情報をDBへ保存します ***"
    shop_model = Shop.new(name: name,
                          twitter_id: nil,
                          address: address,
                          prefecture: prefecture,
                          city: city,
                          lat: shop[:lat],
                          lng: shop[:lon],
                          opening_hours: shop[:opening_hours],
                          phone_number: shop[:phone_number],
                          website: shop[:website],
                          photo_reference: shop[:photo_reference],
                          place_id: shop[:place_id])
    if shop_model.save
      puts "#{name}のShopモデルの作成に成功しました。shop_id: #{shop_model.id}"
    else
      puts "#{name}のShopモデルの作成に失敗しました。"
      puts "[ERROR LOG] #{shop_model.errors.full_messages}"
    end

    # GameMachineモデル作成(店舗とゲームを関連付けする)
    register_relationship_shop_between_game(name, game, shop[:count])

    output_line
  end
end

def register_relationship_shop_between_game(shop_name, game, count)
  puts "\n*** 店舗に設置筐体情報を追加します ***"
  count = 0 if count.nil?
  game_machine = GameMachine.new(shop_id: Shop.find_by(name: shop_name).id, game_id: game.id, count: count)
  if game_machine.save
    puts "#{shop_name}に#{game.title}の設置情報を追加しました。game_machine_id: #{game_machine.id}"
  else
    puts "#{shop_name}に#{game.title}の設置情報を追加しようとしましたが失敗しました。"
    puts "[ERROR LOG] #{game_machine.errors.full_messages}"
  end
end

def get_lat_and_lon(shop)
  url = shop[:detail_page_url]
  page = URI.parse(url).open.read
  document = Nokogiri::HTML(page)
  # サーバー負荷軽減のため待機
  sleep 10

  return if document.at_css('button#routesearch_btn').blank?

  reg = /\d{1,3}\.\d*/
  shop[:lat] = document.at_css('button#routesearch_btn')[:onclick].scan(reg)[0]
  shop[:lon] = document.at_css('button#routesearch_btn')[:onclick].scan(reg)[1]

  shop
end

def output_log(shop, registered_shop, search_word, log_head)
  if registered_shop
    puts "[#{log_head}][店舗一致] DB上の店名: #{registered_shop.name}, スクレイピングした店名: #{shop[:name]}"
    puts "DB上の住所: #{registered_shop.address}, 元の住所: #{shop[:address]}"
    puts "\nDBに店舗情報が登録されています。"
    true
  else
    puts "[#{log_head}][店舗不一致] 検索文字列: #{search_word}"
    false
  end
end

def output_line
  puts '----------------------------'
end

def format_address(address)
  address = address.gsub(/[\uFF61-\uFF9F]+/) { |str| str.unicode_normalize(:nfkc) }
  address = address.gsub('丁目', '-').gsub('番地', '-').gsub('号', '-')
  address = address.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  address = address.gsub(/-(?!\d)/, '')
  address = address.gsub(' ', '').gsub('　', '')
  address = address.gsub('−', '-')
end

def get_places_data(shop)
  # 変数初期化
  auto_data = ''
  name = ''
  address = ''

  puts shop
  puts '### Place APIから店舗情報を取得します ###'

  if shop[:place_id].blank?
    puts 'place idを取得します'
    # AutoCompleteを使用してplace_idを取得
    auto_complete_url = URI.encode "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=#{shop[:name]}&types=establishment&location=#{shop[:lat]},#{shop[:lon]}&radius=1000&language=ja&key=#{ENV['API_KEY']}"
    auto_page = URI.parse(auto_complete_url).open.read
    auto_data = JSON.parse(auto_page)
    shop[:place_id] = auto_data['predictions'].first['place_id'] if auto_data['predictions'].present?
    name = auto_data['predictions'].first['structured_formatting']['main_text'] if auto_data['predictions'].present?
    address = auto_data['predictions'].first['description'] if auto_data['predictions'].present?
    # 検索結果の件数が0の場合別のAPIから取得する
    if auto_data['status'] == 'ZERO_RESULTS' || !address.include?(shop[:prefecture])
      auto_complete_url = URI.encode "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{shop[:name]} #{shop[:prefecture]}#{shop[:city]}&inputtype=textquery&fields=name,place_id,formatted_address&key=#{ENV['API_KEY']}"
      auto_page = URI.parse(auto_complete_url).open.read
      auto_data = JSON.parse(auto_page)
      # 候補が複数ある場合は住所を頼りにする
      auto_data['candidates'].each do |data|
        shop[:place_id] = data['place_id']
        name = data['name']
        address = data['formatted_address']
        break if data['formatted_address'].include? shop[:address][/^\D*/]
      end
    end
  end

  # API節約のためDB上にデータがあればここで終了させる
  if Shop.find_by(name: name)
    shop[:name] = name
    return shop
  end
  # 取得データがなければ終了する
  return nil if auto_data['status'] == 'ZERO_RESULTS'
  # PlaceDetailsを利用して店舗の詳細情報を入手する
  puts '店舗情報を取得します'
  place_detail_url = URI.encode "https://maps.googleapis.com/maps/api/place/details/json?place_id=#{shop[:place_id]}&fields=address_component,adr_address,business_status,formatted_address,geometry,icon,name,photo,place_id,plus_code,type,formatted_phone_number,international_phone_number,opening_hours,website&language=ja&key=#{ENV['API_KEY']}"
  page = URI.parse(place_detail_url).open.read
  data = JSON.parse(page)

  # 取得した位置が緯度または経度が300m以上離れている場合は別店舗とみなしデータの使用をしない
  if shop[:lat].present? && shop[:lon].present?
    puts shop[:lat]
    puts shop[:lon]
    puts data['result']['geometry']['location']['lat']
    puts data['result']['geometry']['location']['lng']
    return shop if (data['result']['geometry']['location']['lat'].to_f - shop[:lat].to_f).abs >= 0.003 || (data['result']['geometry']['location']['lng'].to_f - shop[:lon].to_f).abs >= 0.003
  end

  # データ格納
  shop[:name] = data['result']['name']
  shop[:address] = data['result']['formatted_address'][/[^ \d]..??[都道府県].*/]
  shop[:phone_number] = data['result']['formatted_phone_number']
  shop[:lat] = data['result']['geometry']['location']['lat']
  shop[:lon] = data['result']['geometry']['location']['lng']
  shop[:opening_hours] = data['result']['opening_hours']['periods'] if data['result']['opening_hours'].present?
  shop[:website] = data['result']['website']
  shop[:photo_reference] = data['result']['photos'][0]['photo_reference'] if data['result']['photos'].present?

  # 例外処理
  shop[:address] = '愛知県岡崎市戸崎町大道西-20' if data['result']['formatted_address'] == 'Daidonishi-２０ Tosakicho, Okazaki, Aichi 444-0840 日本'
  shop[:address] = '北海道岩見沢市大和4条8-1' if data['result']['formatted_address'] == '8 Chome-１ Yamato 4 Jo, Iwamizawa, Hokkaido 063-0854 日本'
  shop[:address] = '宮城県登米市南方町新島前-46' if data['result']['formatted_address'] == 'Shinshimamae-４６ Minamikatamachi, Tome, Miyagi 987-0404 日本'
  shop[:address] = '北海道石狩市緑苑台中央1-2' if data['result']['formatted_address'] == '1 Chome-2 Ryokuendaichuo, Ishikari, Hokkaido 061-3230 日本'
  shop[:address] = '新潟県燕市井土巻3-65' if data['result']['formatted_address'] == '3 Chome-６５ Idomaki, Tsubame, Niigata 959-1232 日本'
  shop[:address] = '大阪府河内長野市本町２４−１ ノバティながの北館 4Ｆ' if data['result']['formatted_address'] == '日本、〒586-0015 大阪府内長野市本町２４−１ ノバティながの北館 4Ｆ'
  if data['result']['formatted_address'][-2,2] == '日本' && data['result']['formatted_address'].include?(shop[:prefecture])
    shop[:address] = data['result']['formatted_address'].split(' ').reverse.join[/[^ \d]..??[都道府県].*/]
  end

  puts shop
  shop
end

def update_db(i)
  shops = []
  shops = Shop.where(prefecture: Prefecture.find(i))

  shops.each do |s|
    shop = {  name: s.name,
              lat: s.lat,
              lon: s.lng,
              place_id: s.place_id,
              prefecture: s.prefecture.name,
              city: s.city.name }
    shop = get_places_data shop

    next if shop.nil?
    # 取得した位置が緯度または経度が300m以上離れている場合は別店舗とみなし更新をしない
    next if ((s.lat.to_f - shop[:lat].to_f).abs >= 0.003 || (s.lng.to_f - shop[:lon].to_f).abs >= 0.003) && s.lat.present? && s.lng.present?

    s.update( name: shop[:name],
              address: shop[:address],
              lat: shop[:lat],
              lng: shop[:lon],
              opening_hours: shop[:opening_hours],
              phone_number: shop[:phone_number],
              website: shop[:website],
              photo_reference: shop[:photo_reference],
              place_id: shop[:place_id])
  end
end

def get_need_to_register_shops(shops_all)
  # 変数初期化
  shops = []

  shops_all.each do |shop|
    puts shop
    # DBに同店舗が登録されているか確認
    registered_shop = Shop.find_by(name: shop[:name])
    registered_shop = Shop.find_by(address: shop[:address]) if registered_shop.nil?
    registered_shop = Shop.find_by(address: format_address(shop[:address])) if registered_shop.nil?

    if registered_shop
      # GameMachineモデル作成(店舗とゲームを関連付けする)
      register_relationship_shop_between_game(registered_shop.name, Game.find_by(title: shop[:game]), shop[:count])
    else
      # データベースに登録するデータを配列に格納
      shops << shop
    end
    output_line
  end

  shops
end

def start_message(prefecture, game_title)
  puts "#{prefecture}で#{game_title}が設置されている店舗のスクレイピングを開始します。"
end
