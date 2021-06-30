FactoryBot.define do
  factory :shop do
    sequence(:name) { |n| "ゲームセンター#{n}号店" }
    twitter_id { "twitter_id" }
    opening_time { Time.local(2021, 1, 1, 9, 0, 0) }
    closing_time { Time.local(2021, 1, 1, 23, 30, 0) }
    address { "東京都新宿区南新新宿1-1-1" }
    association :prefecture
    association :city
  end
end
