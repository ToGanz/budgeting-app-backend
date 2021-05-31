FactoryBot.define do
  factory :category do
    name { Faker::Alphanumeric.unique.alpha(number: 10) }
    user
  end
end
