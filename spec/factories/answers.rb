FactoryGirl.define do
  factory :answer do
    association :question, factory: :question
    description "MyText"
  end
end
