FactoryBot.define do
  factory :game do
    app_uid { Faker::Crypto.md5 }

    name { Faker::App.name }
    image { Faker::Internet.url }
  end
end
