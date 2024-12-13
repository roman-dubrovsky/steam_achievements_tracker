FactoryBot.define do
  factory :achievement_user do
    achievement
    game_user { association :game_user, game: achievement.game }

    factory :completed_achievement_user do
      completed { true }
      completed_at {  Faker::Time.backward(days: rand(1..100)) }
    end
  end
end
