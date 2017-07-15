require 'rails_helper'

RSpec.describe MyPoll, type: :model do
  it{ should validate_presence_of :title }
  it{ should_not allow_value("a").for(:title) }
  it{ should validate_length_of(:title).is_at_least(10).is_at_most(30) }

  it{ should validate_presence_of :description }
  it{ should validate_length_of(:description).is_at_least(15).is_at_most(200) }
  it{ should belong_to(:user) }

  it{ should validate_presence_of :expires_at }

  it "should return valid when is not expired" do
  	my_poll = FactoryGirl.create(:my_poll, expires_at: DateTime.now + 1.minute)
  	expect(my_poll.is_valid?).to eq(true)
  end

  it "should return valid when is not expired" do
  	my_poll = FactoryGirl.create(:my_poll, expires_at: DateTime.now - 1.minute)
  	expect(my_poll.is_valid?).to eq(false)
  end
end
