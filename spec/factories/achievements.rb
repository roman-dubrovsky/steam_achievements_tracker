FactoryBot.define do
  factory :achievement do
    game

    uid { Faker::Crypto.md5 }
    name { Faker::Games::Dota.hero }

    hidden { false }
    description { Faker::Games::Dota.quote }

    icon { Faker::Internet.url }
    icongray { Faker::Internet.url }

    factory :hidden_achievement do
      hidden { true }
      description { "" }
    end

    trait :with_notes do
      notes { Faker::Games::Dota.quote }
    end
  end
end
