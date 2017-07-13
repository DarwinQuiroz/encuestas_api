class Token < ApplicationRecord
  belongs_to :user

  before_create :generate_token

  def is_valid?
  	DateTime.now < self.expires_at
  end

  private
  #se genera cadenas Random mientras exista algún
  #token con esa misma cadena que se acaba de crear
  	def generate_token
  		begin
  			self.token = SecureRandom.hex
  		end while Token.where(token: self.token).any?
  		# ||= Valida que no se haya asignado un valor a este campo y lo re asigna
  		self.expires_at ||= DateTime.now + 1.month
  	end
end
