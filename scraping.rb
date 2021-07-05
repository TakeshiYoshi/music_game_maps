require 'nokogiri'
require 'open-uri'

def register_shop_data(shops)
  # Qiita記事参考: https://qiita.com/zakuroishikuro/items/066421bce820e3c73ce9
  city_reg = /((?:旭川|伊達|石狩|盛岡|奥州|田村|南相馬|那須塩原|東村山|武蔵村山|羽村|十日町|上越|富山|野々市|大町|蒲郡|四日市|姫路|大和郡山|廿日市|下松|岩国|田川|大村)市|.+?郡(?:玉村|大町|.+?)[町村]|.+?[市区町村])/
  shops.each do |shop|
    name = shop[:name]
    address = shop[:address]
    # サイト上のデータ不備を修正
    address = address.gsub('東員', '東員町') if address.include?('弁郡東員大字長深字築田')
    address = address.gsub('大舘市', '大館市') if address.include?('大舘市御成町')
    address = address.gsub('桶川都市事業', '桶川市日出谷東地内') if address.include?('桶川都市事業')
    address = address.gsub('篠山市', '丹波篠山市') if address.include?('篠山市')
    address = address.gsub('中頭郡', '中頭郡北中城村ライカム') if address.include?('中頭郡ライカム')
    prefecture = Prefecture.find(shop[:prefecture_id])
    # addressから市区町村を抽出
    city = address.match(city_reg).to_s
    # 例外処理
    city = city.gsub('山口市小郡前田町', '山口市') if city == '山口市小郡前田町'
    # 「〜郡」を除去
    city = city.split('郡').last if city.include?('余市') || !city.include?('市')
    # cityモデルを格納
    city = prefecture.cities.find_by(name: city)
    # ゲームモデル取得
    game = Game.find_by(title: shop[:game])
    # 開店, 閉店時間
    opening_time = shop[:operation_time].present? ? Chronic.parse("2000/01/01 #{shop[:operation_time].split('～').first}") : nil
    closing_time = shop[:operation_time].present? ? Chronic.parse("2000/01/01 #{shop[:operation_time].split('～').last}") : nil
    # Shopモデル作成

    # デバッグ用ログ出力
    puts name
    puts address
    puts prefecture.name
    puts city.name

    puts "\n*** 店舗情報をDBへ保存します ***"
    shop_model = Shop.new(name: name,
                          twitter_id: nil,
                          opening_time: opening_time,
                          closing_time: closing_time,
                          address: prefecture.name + address,
                          prefecture_id: prefecture.id,
                          city_id: city.id,
                          lat: shop[:lat],
                          lon: shop[:lon])
    if shop_model.save
      puts "#{name}のShopモデルの作成に成功しました。shop_id: #{shop_model.id}"
    else
      puts "#{name}のShopモデルの作成に失敗しました。"
      puts "[ERROR LOG] #{shop_model.errors.full_messages}"
    end

    # GameMachineモデル作成(店舗とゲームを関連付けする)
    register_relationship_shop_between_game(name, game, shop[:count])

    # ログ出力
    puts name
    puts prefecture.name + address
    puts prefecture.name
    puts city.name
    puts shop[:operation_time].split('～').first if shop[:operation_time].present?
    puts shop[:operation_time].split('～').last if shop[:operation_time].present?
    puts game.title
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

def get_operation_time(shop)
  url = shop[:detail_page_url]
  page = URI.parse(url).open.read
  document = Nokogiri::HTML(page)
  # サーバー負荷軽減のため待機
  sleep 10

  return if document.at_css("li:contains('営業時間')").blank?

  reg = /\d{1,2}:\d{1,2}～\d{1,2}:\d{1,2}/
  shop[:operation_time] = document.at_css("li:contains('営業時間')").text.match(reg).to_s
end

def get_lat_and_lon(shop)
  # データベースに登録されているか確認しされていれば処理を飛ばす
  return if check_duplication(shop)

  url = shop[:detail_page_url]
  page = URI.parse(url).open.read
  document = Nokogiri::HTML(page)
  # サーバー負荷軽減のため待機
  sleep 10

  return if document.at_css('button#routesearch_btn').blank?

  reg = /\d{1,3}\.\d*/
  shop[:lat] = document.at_css('button#routesearch_btn')[:onclick].scan(reg)[0]
  shop[:lon] = document.at_css('button#routesearch_btn')[:onclick].scan(reg)[1]
end

def update_registered_shop(shop, registered_shop)
  puts "\n*** 既存データの更新を行います ***"
  # 住所がより詳細に取得出来た場合更新する
  address = shop[:address].size > registered_shop.address.size ? shop[:address] : registered_shop.address
  # 緯度が登録されていない場合更新する
  lat = registered_shop.lat.presence || shop[:lat]
  # 経度が登録されていない場合更新する
  lon = registered_shop.lon.presence || shop[:lon]
  puts '取得データ'
  puts "  住所: #{shop[:address]}"
  puts "  緯度: #{shop[:lat]}"
  puts "  経度: #{shop[:lon]}"
  puts '既存データ'
  puts "  住所: #{registered_shop.address}"
  puts "  緯度: #{registered_shop.lat}"
  puts "  経度: #{registered_shop.lon}"

  if registered_shop.update(address: address, lat: lat, lon: lon)
    puts "既存データを更新しました。 店舗名: #{registered_shop.name}"
    puts "  住所: #{registered_shop.address}"
    puts "  緯度: #{registered_shop.lat}"
    puts "  経度: #{registered_shop.lon}"
  else
    puts "既存データの更新に失敗しました。 店舗名: #{registered_shop.name}"
  end
end

def check_duplication(shop)
  puts '*** 既存データが存在するかチェックを行います ***'
  # 手段1: 店名の一致検索
  registered_shop = Shop.find_by(name: shop[:name])
  registered_shop = Shop.find_by(name: "#{shop[:name]}店") if registered_shop.nil?
  registered_shop = Shop.find_by(name: shop[:name].chop) if registered_shop.nil?
  # 店名が被った際は店名の後ろに(県名)を追記する
  if registered_shop.present? && registered_shop.prefecture.id != shop[:prefecture_id]
    shop[:name] = "#{shop[:name]}(#{Prefecture.find(shop[:prefecture_id]).name})"
    registered_shop = nil
  end
  return registered_shop if output_log(shop, registered_shop, shop[:name], '1.店名の一致検索')

  # 手段2: 住所(フル)の一致検索
  shop_address = shop[:address]
  registered_shop = Shop.find_by(address: shop_address)
  # 住所（〜号）が同じで住所（〜号）以下がある場合、店舗名の先頭3文字を比較し違っていれば別店舗として登録する
  # ショッピングモール内で複数ゲーセンがあると同じ住所で別店舗が存在するため
  registered_shop = nil if different_shop_in_same_shopping_mole?(shop, registered_shop)
  return registered_shop if output_log(shop, registered_shop, shop_address, '2.住所の一致検索')

  # 手段3: 住所(〜号)の一致検索
  reg = /^\D*[\d|\-|条]*(?=.*)/
  shop_address = shop[:address][reg]
  registered_shop = Shop.where('address LIKE ?', "%#{shop_address}%").first unless shop_address.nil?
  # 住所（〜号）が同じで住所（〜号）以下がある場合、店舗名の先頭3文字を比較し違っていれば別店舗として登録する
  # ショッピングモール内で複数ゲーセンがあると同じ住所で別店舗が存在するため
  return nil if different_shop_in_same_shopping_mole?(shop, registered_shop)
  return registered_shop if output_log(shop, registered_shop, shop_address, '3.住所(〜号)の一致検索')

  # 手段4: 緯度経度の一致検索
  # 都会の場合はゲームセンター同士の位置が近いためこの手段は用いない
  return if Prefecture.find(shop[:prefecture_id]).name == '東京都'
  return if Prefecture.find(shop[:prefecture_id]).name == '大阪府'
  return if shop[:lat].nil? || shop[:lon].nil?

  reg = /\d{1,3}\.\d{3}/
  lat = shop[:lat][reg]
  lon = shop[:lon][reg]
  registered_shop = Shop.where('lat LIKE ? AND lon LIKE ?', "#{lat}%", "#{lon}%").first
  # 住所（〜号）が同じで住所（〜号）以下がある場合、店舗名の先頭3文字を比較し違っていれば別店舗として登録する
  # ショッピングモール内で複数ゲーセンがあると同じ住所で別店舗が存在するため
  return if different_shop_in_same_shopping_mole?(shop, registered_shop)
  return registered_shop if output_log(shop, registered_shop, "緯度#{lat} 経度#{lon}", '4.緯度経度の一致検索')

  puts "\nDBに店舗情報が登録されていません。"
end

def different_shop_in_same_shopping_mole?(shop, registered_shop)
  reg_shopping_mole = /^\D*[\d|\-|条]*(.*)/
  registered_shop && shop[:address][reg_shopping_mole, 1].present? && shop[:name][0, 3] != registered_shop.name[0, 3] && (shop[:address][reg_shopping_mole, 1].include?('イオン') || shop[:address][reg_shopping_mole, 1].include?('けやき') || shop[:address][reg_shopping_mole, 1].include?('アリオ') || shop[:address][reg_shopping_mole, 1].include?('パルナ') || shop[:address][reg_shopping_mole, 1].include?('ららぽーと'))
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

def format_shop_name(shop_name)
  shop_name = shop_name.gsub(/[\uFF61-\uFF9F]+/) { |str| str.unicode_normalize(:nfkc) }
  shop_name = shop_name.gsub(' ', '')
  shop_name = shop_name.gsub('　', '')
  shop_name = shop_name.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  # 例外処理
  shop_name = shop_name.gsub('T／S', 'タイトーステーション')
  shop_name = shop_name.gsub('T/S', 'タイトーステーション')
  shop_name = shop_name.gsub('タイトー旭サンモール店', 'タイトーステーション旭サンモール店')
  shop_name = shop_name.gsub('DAIKEIEN', '大慶園')
  shop_name = shop_name.gsub('サードプラネットB京都二条店', 'THE3RDプラネットBiVi京都二条店')
end

def format_address(address)
  address = address.gsub(/[\uFF61-\uFF9F]+/) { |str| str.unicode_normalize(:nfkc) }
  if address.include? '北海道'
    address = address.gsub(/([0123456789]*)(条)/) { conversion_from_num_to_kanji(Regexp.last_match(1).to_i) + Regexp.last_match(2) }
  end
  address = address.gsub(/([〇一二三四五六七八九十百千]*)(丁目|番地|号)/) { Regexp.last_match(1).tr('〇一二三四五六七八九', '0123456789') + Regexp.last_match(2) }
  address = address.gsub(/([十百千])(丁目|番地|号)/) { Regexp.last_match(1).gsub('十', '10').gsub('百', '100').gsub('千', '1000') + Regexp.last_match(2) }
  address = address.gsub('丁目', '-').gsub('番地', '-').gsub('号', '-')
  address = address.gsub(/([0123456789]*)(条)/) { conversion_from_num_to_kanji(Regexp.last_match(1).to_i) + Regexp.last_match(2) }
  address = address.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  address = address.gsub(/(\d+)十(\d+)/) { Regexp.last_match(1) + Regexp.last_match(2) }
  address = address.gsub(/(\d+)百(\d+)/) { Regexp.last_match(1) + Regexp.last_match(2) }
  address = address.gsub(/(\d+)千(\d+)/) { Regexp.last_match(1) + Regexp.last_match(2) }
  address = address.gsub(/十(\d+)/) { "1#{Regexp.last_match(1)}" }
  address = address.gsub(/百(\d+)/) { "1#{Regexp.last_match(1)}" }
  address = address.gsub(/千(\d+)/) { "1#{Regexp.last_match(1)}" }
  address = address.gsub(/(\d+)十/) { "#{Regexp.last_match(1)}0" }
  address = address.gsub(/(\d+)百/) { "#{Regexp.last_match(1)}0" }
  address = address.gsub(/(\d+)千/) { "#{Regexp.last_match(1)}0" }
  address = address.gsub(/(\d+)十(\d+)/) { (Regexp.last_match(1) || 1).to_i * 10 + Regexp.last_match(2).to_i }
  address = address.gsub(/(\d+)百(\d+)/) { (Regexp.last_match(1) || 1).to_i * 100 + Regexp.last_match(2).to_i }
  address = address.gsub(/(\d+)千(\d+)/) { (Regexp.last_match(1) || 1).to_i * 1000 + Regexp.last_match(2).to_i }
  address = address.gsub(/-(?!\d)/, '')
  address = address.gsub(' ', '').gsub('　', '')
  address = address.gsub('−', '-')
end

def conversion_from_num_to_kanji(n)
  number = 0..9
  kanji = ['', '一', '二', '三', '四', '五', '六', '七', '八', '九']
  num_kanji = Hash[number.zip(kanji)]
  digit = [1000, 100, 10]
  kanji_keta = %w[千 百 十]
  num_kanji_keta = Hash[digit.zip(kanji_keta)]
  num = n
  str = ''
  digit.each do |d|
    tmp = num / d
    str << (if tmp.zero?
              ''
            else
              ((tmp == 1 ? '' : num_kanji[tmp]) + num_kanji_keta[d])
            end)
    num %= d
  end
  str << num_kanji[num]
  str
end
