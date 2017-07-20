class ApplicationController < ActionController::API
	#before_action :authenticate
	before_action :set_jbuilder_defaults
	
	protected
	def authenticate
		token_str = params[:token]
		token = Token.find_by(token: token_str)

		if token.nil? || !token.is_valid?
			error!("El token es inválido.!", :unauthorized)
		else
			@current_user = token.user
		end
	end

	def set_jbuilder_defaults
		@errors = []
	end

	def error!(message, status)
		@errors << message
		response.status = status
		render "api/v1/errors", {formats: :json}
	end

	def error_array!(array, status)
		@errors = @errors + array
		response.status = status
		render "api/v1/errors", {formats: :json}
	end

	def authenticate_owner(owner)
		if owner != @current_user
			render json: { errors: "No tienes autorizado realiazar esta acción.!" }, status: :unauthorized	
		end
	end
end
