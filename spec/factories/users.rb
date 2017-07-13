FactoryGirl.define do
  factory :user do
    sequence(:email){|n| "user_#{n}@factory.com"}
    sequence(:name){|n| "user_#{n}"}
    provider "facebook"
    uid "qwe214wser23r3da"
  end
end
