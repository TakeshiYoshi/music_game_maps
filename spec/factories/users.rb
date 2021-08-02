FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@foo.bar" }
    password { 'Foobarhogehoge' }
    password_confirmation { 'Foobarhogehoge' }
    nickname { Faker::Games::Touhou.character }
    description { Faker::Lorem.sentence(word_count: 30) }
  end
end
