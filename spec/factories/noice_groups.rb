FactoryGirl.define do
  factory :notice_group do
    transient do
      notices_count 4
    end

    after(:create) do |notice_group, evaluator|
      create_list(:notice, evaluator.notices_count, notice_group: notice_group)
    end
  end
end