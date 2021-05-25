FactoryBot.define do
  factory :plan do
    title { Faker::Lorem.unique.word }
  end
end
