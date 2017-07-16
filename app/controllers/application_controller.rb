class ApplicationController < ActionController::API
	#before_action :authenticate
	
	protected
	def authenticate
		token_str = params[:token]
		token = Token.find_by(token: token_str)

		if token.nil? || !token.is_valid?
			render json: { error: "El token es inválido.!" }, status: :unauthorized
		else
			@current_user = token.user
		end
	end


	def authenticate_owner(owner)
		if owner != @current_user
			render json: { errors: "No tienes autorizado realiazar esta acción.!" }, status: :unauthorized	
		end
	end
end
