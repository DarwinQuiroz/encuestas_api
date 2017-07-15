class MyPoll < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: {in: 10..30}
  validates :description, presence: true, length: {in: 15..200}
  validates :expires_at, presence: true
  validates :user, presence: true

  def is_valid?
  	DateTime.now < self.expires_at
  end
end
