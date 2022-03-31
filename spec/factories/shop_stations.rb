FactoryBot.define do
  factory :shop_station do
    association :shop
    association :station
    distance { 1 }
  end
end
