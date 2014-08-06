FactoryGirl.define do
  factory :question do
    association :user

    sequence(:body) { |n| "I need help. I can't get #{n} to work." }
    sequence(:title) { |n| "Help me with #{n} not working" }

    trait :with_accepted_answer do
      association :accepted_answer, factory: :answer
    end
  end
end
