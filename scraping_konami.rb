require 'nokogiri'
require 'open-uri'

def scraping_konami(game_key)
  # 変数初期化
  sleep_time = 15
  shops = []
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
  Prefecture.all.each do |prefecture|
    puts "#{prefecture.name}で#{game_title[game_key.to_sym]}が設置されている店舗のスクレイピングを開始します。"
    prefecture_id = prefecture.id.to_s.rjust(2, '0')
    i = 1
    begin
      url = "https://p.eagate.573.jp/game/facility/search/p/list.html?gkey=#{game_key}&paselif=false&pref=JP-#{prefecture_id}&finder=area&page=#{i}"
      charset = nil
      page =  URI.open(url).read
      document = Nokogiri::HTML(page)

      # 店舗数0の時の処理
      if document.css('div.cl_shop_bloc').blank?
        puts '[scraping] 店舗数: 0'
        # サーバー負荷軽減のため5秒待機
        sleep sleep_time
        break
      end

      document.css('div.cl_shop_bloc').each do |node|
        shop = {  name: node['data-name'],
                  address: node['data-address'],
                  prefecture_id: prefecture.id,
                  operation_time: node['data-operationtime'],
                  lat: node['data-latitude'],
                  lon: node['data-longitude'],
                  game: game_title[game_key.to_sym] }
        shops << shop
      end
      # 店舗数取得
      shop_cnt = document.at('//div[@class="cl_search_result"]').text.split('件')[0] if i == 1
      puts "[scraping] #{shops.size}件目まで取得中..."
      i += 1
      # サーバー負荷軽減のため5秒待機
      sleep sleep_time

      # ループ停止判定チェック
      unless document.css('td.cl_pager_mark span').present? && document.css('td.cl_pager_mark span').last.text == '>>'
        break
      end
    end while true
  end

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
    # サイト上のデータ不備を修正
    address = address.gsub('東員', '東員町') if address.include?('弁郡東員大字長深字築田')
    prefecture = Prefecture.find(shop[:prefecture_id])
    # addressから市区町村を抽出
    city = address.match(city_reg).to_s
    # 例外処理
    city = city.gsub('山口市小郡前田町', '山口市') if city == '山口市小郡前田町'
    # 「〜郡」を除去
    city = city.split('郡').last unless city.include?('市')
    # cityモデルを格納
    city = prefecture.cities.find_by(name: city)
    # ゲームモデル取得
    game = Game.find_by(title: shop[:game])
    # 開店, 閉店時間
    opening_time = shop[:operation_time].present? ? Chronic.parse("2000/01/01 #{shop[:operation_time].split('～').first}") : nil
    closing_time = shop[:operation_time].present? ? Chronic.parse("2000/01/01 #{shop[:operation_time].split('～').last}") : nil

    puts name
    puts address
    puts prefecture.name
    puts city.name
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

    # GameMachineモデル作成(店舗とゲームを関連付けする)
    game_machine = GameMachine.new(shop_id: Shop.find_by(name: name).id,
                                   game_id: game.id,
                                   count: 0)
    if game_machine.save
      puts "#{name}に#{game.title}の設置情報を追加しました。game_machine_id: #{game_machine.id}"
    else
      puts "#{name}に#{game.title}の設置情報を追加しようとしましたが失敗しました。"
      puts "[ERROR LOG] #{game_machine.errors.full_messages}"
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
