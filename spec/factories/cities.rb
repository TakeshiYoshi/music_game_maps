FactoryBot.define do
  factory :city do
    sequence(:name) { |n| "第#{n}江戸川区" }
    association :prefecture
  end
end
