FactoryBot.define do
  factory :station_company, class: 'Station::Company' do
    name { "MyString" }
    code { 1 }
  end
end
