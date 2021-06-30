FactoryBot.define do
  factory :playing_game do
    association :user
    association :game
  end
end
