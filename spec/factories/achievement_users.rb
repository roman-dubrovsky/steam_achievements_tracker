# frozen_string_literal: true

FactoryBot.define do
  factory :achievement_user do
    achievement
    game_user { association :game_user, game: achievement.game }

    completed { [false, true].sample }
    completed_at { completed? ? Faker::Time.backward(days: rand(1..100)) : nil }
  end
end
