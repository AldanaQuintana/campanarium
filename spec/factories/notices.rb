FactoryGirl.define do
  factory :notice do
    title "MyString"
    body "Faker::Lorem.paragraph"
    source "MyString"
    sequence :url do |n|
      "#{n}-url"
    end
  end

end
