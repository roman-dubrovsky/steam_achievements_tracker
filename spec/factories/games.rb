FactoryBot.define do
  factory :game do
    app_uid { Faker::Crypto.md5 }
  end
end
