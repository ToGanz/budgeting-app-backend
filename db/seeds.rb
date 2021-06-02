# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(name: 'test1',
        email: 'test@test.com',
        password: 'password')

plan = Plan.create!(title: 'plan1', user_id: user.id)

3.times do
  category = Category.create!(name: Faker::Commerce.product_name, user_id: user.id)
 
  2.times do
    transaction = Transaction.create!(
      description: Faker::Commerce.product_name, 
      amount: rand(1.0..100.0),
      plan_id: plan.id,
      category_id: category.id
    )
  end
end