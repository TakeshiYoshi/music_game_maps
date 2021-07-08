FactoryBot.define do
  factory :shop do
    sequence(:name) { |n| "ゲームセンター#{n}号店" }
    twitter_id { "twitter_id" }
    address { "東京都新宿区南新新宿1-1-1" }
    association :prefecture
    association :city
  end
end
