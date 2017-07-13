FactoryGirl.define do
  factory :token do
    expires_at "2017-07-11 20:10:50"
    association :user, factory: :user
  end
end
