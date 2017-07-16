class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :set_poll
  before_action(only: [:update, :destroy, :create]) {|controlador| controlador.authenticate_owner(@poll.user)}

  "GET /polls/1/questions"
  def index
  	@questions = @poll.questions
    render "api/v1/questions/index", {formats: :json}
  end

  "GET /polls/1/questions/2"
  def show
    render "api/v1/questions/show", {formats: :json}
  end

  "POST /polls/1/questions"
  def create
    @question = @poll.questions.new(question_params)
    if @question.save
      render "api/v1/questions/show", {formats: :json}
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  "PUT PATCH /polls/1/questions/2"
  def update
    if @question.update(question_params)
      render "api/v1/questions/show", {formats: :json}
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  "DELETE /polls/1/questions/2"
  def destroy
    @question.destroy
    head :ok
  end

  private
  	def question_params
      params.require(:question).permit(:description)
  	end

    def set_poll
      @poll = MyPoll.find(params[:poll_id])
    end

  	def set_question
  		@question = Question.find(params[:id])
  	end 	
end