require 'csv'

def get_companies
  # CSV読み込み
  file_path = 'lib/station/data/company.csv'
  csv_data = CSV.read(file_path)

  csv_data.each do |data|
    e_status = data[8].to_i
    name = data[2]
    code = data[0].to_i

    # e_status != 0の場合は運行していないためスキップ
    next unless e_status.zero?

    # 既に同コードがある場合はスキップ
    next if Company.find_by(code: code).present?

    Company.create(name: name, code: code)

    puts "#{name} #{code} を作成した"
  end
end

def get_lines
  # CSV読み込み
  file_path = 'lib/station/data/line.csv'
  csv_data = CSV.read(file_path)

  csv_data.each do |data|
    e_status = data[11].to_i
    name = data[2]
    code = data[0].to_i
    company_code = data[1].to_i
    company = Company.find_by(code: company_code)

    # e_status != 0の場合は運行していないためスキップ
    next unless e_status.zero?

    # 既に同コードがある場合はスキップ
    next if company.present? && Line.find_by(code: code)

    Line.create(name: name, code: code, company_id: company.id)

    puts "#{company.name}: #{name} #{code} を作成した"
  end
end

def get_stations
  # CSV読み込み
  file_path = 'lib/station/data/station.csv'
  csv_data = CSV.read(file_path)

  csv_data.each do |data|
    e_status = data[13].to_i
    name = data[2]
    code = data[0].to_i
    line_code = data[5].to_i
    line = Line.find_by(code: line_code)
    pref_code = data[6].to_i
    prefecture = Prefecture.find(pref_code)
    index_number = data[1][-2..-1].to_i
    lat = data[10].to_f
    lng = data[9].to_f

    puts line_code

    # e_status != 0の場合は運行していないためスキップ
    next unless e_status.zero?

    # 既に同コードがある場合はスキップ
    next if line.present? && prefecture.present? && Station.find_by(code: code)

    Station.create(name: name, code: code, line_id: line.id, prefecture_id: prefecture.id, lat: lat, lng: lng, index_number: index_number)

    puts "#{line.name} #{index_number}: #{name} #{code} を作成した. #{prefecture.name}"
  end
end
