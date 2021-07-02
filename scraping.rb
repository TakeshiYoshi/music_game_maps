require 'nokogiri'
require 'open-uri'

def scraping_konami(game_key)
  # 変数初期化
  shops = []
  shop_cnt = 0
  i = 1
  game_title = {
    SDVX_VM: 'SOUND VOLTEX -Valkyrie model-',
    SDVX: 'SOUND VOLTEX',
    PMSP: "pop'n music",
    IIDX_LN: 'beatmania IIDX LIGHTNING MODEL',
    IIDX: 'beatmania IIDX',
    NOSTALGIA: 'ノスタルジア',
    GITADORAGF: 'GuitarFreaks',
    GITADORADM: 'DrumMania',
    DDR: 'DDR',
    DDR20TH: 'DDR 20th model',
    JUBEAT: 'jubeat',
    DAN: 'DANCERUSH',
    REFLECC: 'REFLEC BEAT',
    MUSECA: 'MUSECA',
    DANEVOAC: 'DanceEvolution'
  }

  # 以下スクレイピング処理
  begin
    url = "https://p.eagate.573.jp/game/facility/search/p/list.html?gkey=#{game_key}&paselif=false&finder=ll&latitude=0&longitude=0&page=#{i}"
    charset = nil
    page =  URI.open(url).read
    document = Nokogiri::HTML(page)
    document.css('div.cl_shop_bloc').each do |node|
      shop = {  name: node['data-name'],
                address: node['data-address'],
                operation_time: node['data-operationtime'],
                lat: node['data-latitude'],
                lon: node['data-longitude'],
                game: game_title[game_key.to_sym] }
      shops << shop
    end
    # 店舗数取得
    shop_cnt = document.at('//div[@class="cl_search_result"]').text.split('件')[0] if i == 1
    puts "[scraping] #{shops.size}件取得中..."
    i += 1
    # サーバー負荷軽減のため5秒待機
    sleep 5
  end while shops.size < shop_cnt.to_i

  # スクレイピング処理結果出力
  puts "\nResult\n#{shops}"
  puts "\n検索結果: #{shops.size}, 取得件数: #{shop_cnt}, 取得漏れ: #{shops.size - shop_cnt.to_i}件\n"
  puts '----------------------------'

  register_shop_data shops
end

def register_shop_data(shops)
  # Qiita記事参考: https://qiita.com/zakuroishikuro/items/066421bce820e3c73ce9
  city_reg = /((?:旭川|伊達|石狩|盛岡|奥州|田村|南相馬|那須塩原|東村山|武蔵村山|羽村|十日町|上越|富山|野々市|大町|蒲郡|四日市|姫路|大和郡山|廿日市|下松|岩国|田川|大村)市|.+?郡(?:玉村|大町|.+?)[町村]|.+?[市区町村])/

  shops.each do |shop|
    # スクレイピングデータのフォーマットを整える
    name = shop[:name].gsub(' ', '').gsub('　', '').tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
    address = shop[:address].gsub(' ', '').gsub('　', '').tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
    # addressから市区町村を抽出
    city = address.match(city_reg).to_s
    # 「〜郡」を除去
    city = city.split('郡').last unless city.include?('市')
    # cityモデルを格納
    city = City.find_by(name: city)
    prefecture = city.prefecture
    game = Game.find_by(title: shop[:game])
    # 開店, 閉店時間
    opening_time = shop[:operation_time].present? ? Chronic.parse("2000/01/01 #{shop[:operation_time].split('～').first}") : nil
    closing_time = shop[:operation_time].present? ? Chronic.parse("2000/01/01 #{shop[:operation_time].split('～').last}") : nil

    # Shopモデル作成
    shop_model = Shop.new(name: name,
                          twitter_id: nil,
                          opening_time: opening_time,
                          closing_time: closing_time,
                          address: address,
                          prefecture_id: prefecture.id,
                          city_id: city.id)
    if shop_model.save
      puts "#{name}のShopモデルの作成に成功しました。shop_id: #{shop_model.id}"
    else
      puts "#{name}のShopモデルの作成に失敗しました。"
      puts "[ERROR LOG] #{shop_model.errors.full_messages}"
    end

    # ログ出力
    puts name
    puts prefecture.name + address
    puts prefecture.name
    puts city.name
    puts shop[:operation_time].split('～').first if shop[:operation_time].present?
    puts shop[:operation_time].split('～').last if shop[:operation_time].present?
    puts game.title
    puts '----------------------------'
  end
end
