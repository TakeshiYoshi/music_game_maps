require 'csv'

def get_companies
  # CSV読み込み
  file_path = 'lib/station/company.csv'
  csv_data = CSV.read(file_path)

  csv_data.each do |data|
    e_status = data[8].to_i
    name = data[2]
    code = data[0].to_i

    # e_status != 0の場合は運行していないためスキップ
    next unless e_status.zero?

    # 既に同コードがある場合はスキップ
    next if Station::Company.find_by(code: code).present?

    Station::Company.create(name: name, code: code)

    puts "#{name} #{code} を作成した"
  end
end