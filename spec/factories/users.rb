FactoryGirl.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    name { Faker::Name.name }
  end
end