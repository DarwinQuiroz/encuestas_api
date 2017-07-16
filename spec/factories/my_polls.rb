FactoryGirl.define do
  factory :my_poll do
    association :user, factory: :user
    expires_at "2017-07-13 10:24:47"
    title "MyStringipsum"
    description "MyText Lorem ipsum Lorem"
    factory :poll_with_questions do
    	title "Poll with questions"
    	description "lorem ipsum irem suss spaad sdfsdfs asrwf s"
    	questions { build_list :question, 2 }
    end
  end
end
