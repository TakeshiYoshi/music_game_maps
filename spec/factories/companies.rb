FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "第#{n}電鉄(株)" }
  end
end
