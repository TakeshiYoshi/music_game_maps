FactoryBot.define do
  factory :user_review do
    body { Faker::Lorem.sentence(word_count: 30) }
    association :user
    association :shop
  end
end
