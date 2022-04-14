FactoryBot.define do
  factory :shop_fix_request do
    not_exist { false }
    duplicate { false }
    fix_shop_info { false }
    body { "MyText" }
    status { 1 }

    association :shop
  end
end
