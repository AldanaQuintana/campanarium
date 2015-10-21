FactoryGirl.define do
  factory :notice do
    title "MyString"
    sequence :body do |n|
      "#{n} Faker::Lorem.paragraph"
    end
    source "MyString"
    url "MyString"
  end

end
