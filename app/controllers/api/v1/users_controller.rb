class Api::V1::UsersController < ApplicationController
	
	def create
		if !params[:auth]
			render json: { error: "No se encontró el parámetro auth en la petición" }
		else
			@user = User.from_omniauth(params[:auth])
			@token = @user.tokens.create()

			render "api/v1/users/show", {formats: :json}
		end
	end
end