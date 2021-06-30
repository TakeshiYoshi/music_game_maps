FactoryBot.define do
  factory :game do
    sequence(:title) { |n| "GAME TITLE #{n}" }
  end
end
