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