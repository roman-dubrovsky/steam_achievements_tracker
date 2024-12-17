# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    steam_uid { Faker::Crypto.md5 }
    nickname { Faker::Name.name }
    avatar_url { Faker::Internet.url }
  end
end
