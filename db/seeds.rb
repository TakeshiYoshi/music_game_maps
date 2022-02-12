require 'csv'

# CSV読み込み
file_path = 'lib/自治体一覧表.csv'
csv_data = CSV.read(file_path)

# 都道府県データ抽出
prefectures_list = csv_data.map { |row| row[1] }.uniq

# 市区町村データ抽出
cities_list = csv_data.map do |row|
    next if row[2] == nil
    row[1, 2]
  end.compact

# 都道府県データ作成
prefectures_list.each do |prefecture|
  Prefecture.create!(name: prefecture)
end

# 市区町村データ作成
cities_list.each do |city|
  prefecture = Prefecture.find_by(name: city[0])
  prefecture.cities.create(name: city[1])
end

# ゲームデータ作成
Game.create(title: 'SOUND VOLTEX -Valkyrie model-')
Game.create(title: 'SOUND VOLTEX')
Game.create(title: "pop'n music")
Game.create(title: 'beatmania IIDX LIGHTNING MODEL')
Game.create(title: 'beatmania IIDX')
Game.create(title: 'ノスタルジア')
Game.create(title: 'GuitarFreaks')
Game.create(title: 'DrumMania')
Game.create(title: 'DDR')
Game.create(title: 'DDR 20th model')
Game.create(title: 'jubeat')
Game.create(title: 'DANCERUSH')
Game.create(title: 'REFLEC BEAT')
Game.create(title: 'MUSECA')
Game.create(title: 'DanceEvolution')
Game.create(title: 'CHUNITHM')
Game.create(title: 'maimai')
Game.create(title: 'WACCA')
Game.create(title: 'オンゲキ')
Game.create(title: '太鼓の達人')
Game.create(title: 'GROOVE COASTER')
Game.create(title: 'CHRONO CIRCLE')
