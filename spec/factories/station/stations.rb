FactoryBot.define do
  factory :station_station, class: 'Station::Station' do
    name { "MyString" }
    code { 1 }
    line { nil }
    index_number { 1 }
  end
end
