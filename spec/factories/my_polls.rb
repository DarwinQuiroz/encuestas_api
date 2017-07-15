FactoryGirl.define do
  factory :my_poll do
    association :user, factory: :user
    expires_at "2017-07-13 10:24:47"
    title "MyStringipsum"
    description "MyText Lorem ipsum Lorem"
  end
end
