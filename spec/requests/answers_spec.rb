require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :request do
	
	before :each do
		@token = FactoryGirl.create(:token, expires_at: DateTime.now + 1.month)		
		@poll = FactoryGirl.create(:poll_with_questions, user: @token.user)
		@question = @poll.questions[0]
	end

	let(:valid_params){ {description: "Ruby", question_id: @question.id} }

	describe "POST /polls/:poll_id/answers" do
		context "con usuario válido" do
			before :each do
				post api_v1_poll_answers_path(@poll), 
				params: {answer: valid_params, token: @token.token}
			end

			it {expect(response).to have_http_status(200) }

			it "cambia el contador de respuestas +1" do
				expect{
					post api_v1_poll_answers_path(@poll), 
				params: {answer: valid_params, token: @token.token}
				}.to change(Answer, :count).by(1)
			end

			it "responde con la respuesta creada" do
				json = JSON.parse(response.body)
				expect(json["description"]).to eq(valid_params[:description])
			end
		end

		context "con usuario inválido" do
			
		end
	end

	describe "PUT /polls/:poll_id/questions/:id" do
		before :each do
			@answer = FactoryGirl.create(:answer, question: @question)
			put api_v1_poll_answer_path(@poll, @answer), 
			params: {answer: {description: "Nueva respuesta"}, token: @token.token}
		end

		it {expect(response).to have_http_status(200) }

		it "debe actualizar los campos indicados" do
			@answer.reload
			expect(@answer.description).to eq("Nueva respuesta")
		end
 	end

	describe "DELETE /polls/:poll_id/questions/:id" do
		before :each do
			@answer = FactoryGirl.create(:answer, question: @question)
		end

		it "responde con un status 200" do
			delete api_v1_poll_answer_path(@poll, @answer), params: {token: @token.token}
			expect(response).to have_http_status(200)
		end

		it "cambia el contador de answer -1" do
			expect{
				delete api_v1_poll_answer_path(@poll, @answer), params: {token: @token.token}
				}.to change(Answer, :count).by(-1)
		end
	end
end