FactoryBot.define do
  factory :station do
    sequence(:name) { |n| "第#{n}駅" }
    association :prefecture
    association :line
  end
end
