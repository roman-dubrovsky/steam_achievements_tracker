FactoryBot.define do
  factory :achievement_user do
    achievement
    user

    factory :completed_achievement_user do
      completed { true }
      completed_at {  Faker::Time.backward(days: rand(1..100)) }
    end
  end
end
