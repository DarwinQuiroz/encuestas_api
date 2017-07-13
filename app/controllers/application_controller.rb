class ApplicationController < ActionController::API
	before_action :authenticate
	
	def authenticate
		token_str = params[:token]
		token = Token.find_by(token: token_str)

		if token.ni? || !token.is_valid?
			render json: { error: "El token es inválido.!", status: :unauthorized }
		else
			@current_user = token.user
		end
	end
end
