FactoryBot.define do
  factory :plan do
    title { Faker::Lorem.unique.word }
    user
  end
end
