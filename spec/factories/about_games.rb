FactoryBot.define do
  factory :about_game do
    association :user_review
    association :game
  end
end
