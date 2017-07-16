require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :request do
	
	before :each do
		@token = FactoryGirl.create(:token, expires_at: DateTime.now + 1.month)		
		@poll = FactoryGirl.create(:poll_with_questions, user: @token.user)
	end

	describe "GET /polls/:poll_id/questions" do
		before :each do
			get "/api/v1/polls/#{@poll.id}/questions"
		end
		it {expect(response).to have_http_status(200) }
		
		it "mande la lista de preguntas para la encuesta" do
			json = JSON.parse(response.body)
			expect(json.length).to eq(@poll.questions.count)
		end

		it "manda la descripcion y el id de una pregunta" do
			json_array = JSON.parse(response.body)
			question = json_array[0]
			expect(question.keys).to contain_exactly("id", "description")
		end
	end

	describe "GET /polls/:poll_id/questions/:id" do
		before :each do
			@question = @poll.questions[0]
			get api_v1_poll_question_path(@poll, @question)
		end
		it {expect(response).to have_http_status(200) }
		
		it "mande ña pregunta solicitada en JSON" do
			json = JSON.parse(response.body)
			expect(json["description"]).to eq(@question.description)
		end
	end

	describe "POST /polls/:poll_id/questions" do
		context "con usuario válido" do
			before :each do
				post api_v1_poll_questions_path(@poll), params: {question: {description: "Cual es tu lenguaje favorito?"}, token: @token.token}
			end
			it {expect(response).to have_http_status(200) }

			it "cambia el número de preguntas +1" do
				expect{
					post api_v1_poll_questions_path(@poll), params: {question: {description: "Cual es tu lenguaje favorito?"}, token: @token.token}
					}.to change(Question, :count).by(1)
			end

			it "responde con la pregunta creada" do
				json = JSON.parse(response.body)
				expect(json["description"]).to eq("Cual es tu lenguaje favorito?")
			end
		end

		context "con usuario inválido" do
			before :each do
				new_user = FactoryGirl.create(:dummy_user)
				@new_token = FactoryGirl.create(:token, user: new_user, expires_at: DateTime.now + 1.month)
				post api_v1_poll_questions_path(@poll), 
					params: {question: {description: "Cual es tu lenguaje favorito?"}, token: @new_token.token}
			end
			it {expect(response).to have_http_status(401) }

			it "cambia el número de preguntas 0" do
				expect{
					post api_v1_poll_questions_path(@poll), 
						params: {question: {description: "Cual es tu lenguaje favorito?"}, token: @new_token.token}
					}.to change(Question, :count).by(0)
			end
		end
	end

	describe "PUT /polls/:poll_id/questions/:id" do
		before :each do
			@question = @poll.questions[0]
			patch api_v1_poll_question_path(@poll, @question), 
				params: {question: {description: "Descripcion actualizada de nuevo"}, token: @token.token}
		end
		it {expect(response).to have_http_status(200) }

		it "actualiza los datos indicados" do
			json = JSON.parse(response.body)
			expect(json["description"]).to eq("Descripcion actualizada de nuevo")
		end
 	end

	describe "DELETE /polls/:poll_id/questions/:id" do
		before :each do
			@question = @poll.questions[0]
		end
		it "elimina la pregunta" do
			delete api_v1_poll_question_path(@poll, @question), params: {token: @token.token}
			expect(Question.where(id: @question.id)).to be_empty
		end

		it "reduce el conteo de preguntas -1" do
			expect{
				delete api_v1_poll_question_path(@poll, @question), params: {token: @token.token}
				}.to change(Question,:count).by(-1)
		end
	end
end