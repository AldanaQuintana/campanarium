FactoryGirl.define do
  factory :user, class: User do
    sequence(:email) { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    name { Faker::Name.name }

    factory :admin do
      type "Admin"
    end
  end
end