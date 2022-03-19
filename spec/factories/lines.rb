FactoryBot.define do
  factory :line do
    sequence(:name) { |n| "第#{n}電鉄" }
  end
end
