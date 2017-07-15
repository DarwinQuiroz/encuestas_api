class Api::V1::MyPollsController < ApplicationController
	before_action :authenticate, only: [:create, :update, :destroy]
	before_action :set_poll, only: [:show, :update, :destroy]
	before_action(only: [:update, :destroy]) {|controlador| controlador.authenticate_owner(@poll.user)}

	def index
		@polls = MyPoll.all
		render "api/v1/my_polls/index", {formats: :json}
	end

	def show
		render "api/v1/my_polls/show", {formats: :json}
	end

	def create
		@poll = @current_user.my_polls.new(my_polls_params)
		if @poll.save
			render "api/v1/my_polls/show", {formats: :json}
		else
			render json: { errors: @poll.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def update
		@poll.update(my_polls_params)
		render "api/v1/my_polls/show", {formats: :json}
	end

	def destroy
		@poll.destroy
		render json: { message: "La encuesta fue eliminada.!" }
	end
	
	protected
		def authenticate_owner(owner)
			if owner != @current_user
				render json: { errors: "No tienes autorizado realiazar esta acción.!" }, status: :unauthorized	
			end
		end

	private
		def my_polls_params
			params.require(:poll).permit(:title, :description, :expires_at)
		end

		def set_poll
			@poll = MyPoll.find(params[:id])
		end
end