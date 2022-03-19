FactoryBot.define do
  factory :shop_station do
    association :shop
    association :station
  end
end
