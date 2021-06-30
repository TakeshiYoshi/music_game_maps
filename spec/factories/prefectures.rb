FactoryBot.define do
  factory :prefecture do
    sequence(:name) { |n| "第#{n}東京都" }
  end
end
