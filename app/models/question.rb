class Question < ApplicationRecord
  belongs_to :my_poll
  has_many :answers

  validates :description, presence: true, length: {in: 10..150}
  validates :my_poll, presence: true
end
