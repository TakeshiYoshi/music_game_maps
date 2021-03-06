require './lib/scraping/scraping'

def scraping_konami(game_key)
  # 変数初期化
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
    shops = []
    start_message(prefecture.name, game_title[game_key.to_sym])
    prefecture_id = prefecture.id.to_s.rjust(2, '0')
    1.upto(999) do |i|
      url = "https://p.eagate.573.jp/game/facility/search/p/list.html?gkey=#{game_key}&paselif=false&pref=JP-#{prefecture_id}&finder=area&page=#{i}"
      page = URI.parse(url).open.read
      document = Nokogiri::HTML(page)
      # サーバー負荷軽減のため待機
      sleep $sleep_time

      # 店舗数0の時の処理
      break if document.css('div.cl_shop_bloc').blank?

      document.css('div.cl_shop_bloc').each do |node|
        name = node['data-name']
        lat = node['data-latitude']
        lng = node['data-longitude']
        place_id = Shop.find_by(konami_name: name).place_id if Shop.find_by(konami_name: name)

        # 例外処理
        place_id = 'ChIJzdZ63-DVVDURyOukhz0DiGU' if name == 'トップラン' && prefecture.id == 28
        next if name == 'サイドセブン' # 開店準備中

        shop = {  name: name,
                  konami_name: name,
                  address: prefecture.name + node['data-address'],
                  prefecture: prefecture.name,
                  lat: lat,
                  lon: lng,
                  game: game_title[game_key.to_sym],
                  place_id: place_id }
        # Places APIを用いてデータを整理する
        shop = get_places_data shop
        shops << shop
      end

      puts "[scraping] #{shops.size}件目まで取得中..."

      # ループ停止判定チェック
      pagination_button = document.css('td.cl_pager_mark span')
      unless pagination_button.present? && pagination_button.last.text == '>>'
        break
      end
    end
    puts shops
    # 店舗情報の登録と登録した店舗の配列を取得
    registered_shops = register_shop_data shops
    # 撤去された店舗の筐体情報を削除
    delete_game_machine(registered_shops, game_title[game_key.to_sym], prefecture.id)
  end
end
