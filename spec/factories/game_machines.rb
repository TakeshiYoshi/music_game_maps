FactoryBot.define do
  factory :game_machine do
    association :shop
    association :game
    count { 0 }
  end
end
