FactoryBot.define do
  factory :transaction do
    description { Faker::Lorem.words(number: 4) }
    spending { false }
    amount { Faker::Number.decimal(l_digits: 2) }
    plan
    category
  end
end
