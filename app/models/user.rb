class User < ApplicationRecord
	has_many :tokens
	has_many :my_polls
	
	validates :email, presence: true, email: true, uniqueness: true
	validates :uid, presence: true
	validates :provider, presence: true

	def self.from_omniauth(data)
		where(provider: data[:provider], uid: data[:uid]).first_or_create do |user|
			user.email = data[:info][:email]
		end
		# User.create(provider: data[:provider], uid: data[:uid], email: data[:info][:email])
	end
end
