FactoryBot.define do
  factory :station_line, class: 'Station::Line' do
    name { "MyString" }
    code { 1 }
    company { nil }
  end
end
