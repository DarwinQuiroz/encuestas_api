require 'rails_helper'

RSpec.describe Api::V1::MyPollsController, type: :request do
	describe "GET /polls" do
		before :each do
			FactoryGirl.create_list(:my_poll, 10)
			get "/api/v1/polls"
		end

		it{ expect(response).to have_http_status(200) }

		it "deberia retornar la lista de encuestas" do
			json = JSON.parse(response.body)
			expect(json.length).to eq(MyPoll.count)
		end
	end 

	describe "GET /polls/:id" do
		before :each do
			@poll = FactoryGirl.create(:my_poll)
			get "/api/v1/polls/#{@poll.id}"
		end

		it{ expect(response).to have_http_status(200) }

		it "manda la encuesta solicitada" do
			json = JSON.parse(response.body)
			expect(json["id"]).to eq(@poll.id)
		end

		it "manda los atributus de la encuesta" do
			json = JSON.parse(response.body)
			expect(json.keys).to contain_exactly("id", "title", "description", "user_id", "expires_at")
		end
	end

	describe "POST /polls" do
		context "con token válido" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				post "/api/v1/polls", params: { token: @token.token, poll: {title: "Hola mundoooo", description: "Hola mundo Hola mundo Hola mundo", expires_at: DateTime.now } }
			end
			it{ expect(response).to have_http_status(200) }
			
			it "crea una nueva encuesta" do
				expect{
					post "/api/v1/polls", params: { token: @token.token, poll: {title: "Hola mundoooo", description: "Hola mundo Hola mundo Hola mundo", expires_at: DateTime.now } }
					}.to change(MyPoll, :count).by(1)
			end
		
			it "responde con la encuesta creada" do
				json = JSON.parse(response.body)
				# puts "\n\n ---- #{json} ---- \n\n"
				expect(json["title"]).to eq("Hola mundoooo")
			end
		end

		context "con token inválido" do
			before :each do
				post "/api/v1/polls"
			end

			it{ expect(response).to have_http_status(401) }
		end

		context "parámetros inválidos" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				post "/api/v1/polls", params: { token: @token.token, poll: {title: "Hola mundoooo", expires_at: DateTime.now } }
			end

			it{ expect(response).to have_http_status(422) }
			
			it "responde con los errores al guardar la encuesta" do
				json = JSON.parse(response.body)
				# puts "\n\n --- #{response.body} --- \n\n"
				expect(json["errors"]).to_not be_nil
			end
		end
	end

	describe "PATCH /polls/:id" do
		context "con un token válido" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: @token.user)
				patch api_v1_poll_path(@poll), params: {token: @token.token, poll:{title:"nuevo titulo"}}
			end
			it{ expect(response).to have_http_status(200) }

			it "actualiza la encuesta indicada" do
				json = JSON.parse(response.body)
				expect(json["title"]).to eq("nuevo titulo")
			end
		end

		context "con un token inválido" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: FactoryGirl.create(:dummy_user))
				patch api_v1_poll_path(@poll), params: {token: @token.token, poll:{title:"nuevo titulo"}}
			end
			it{ expect(response).to have_http_status(401) }
		end
	end

	describe "DELETE /polls/:id" do 
		context "con un token válido" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: @token.user)
				
			end
			it{ 
				delete api_v1_poll_path(@poll), params: { token: @token.token }
				expect(response).to have_http_status(200) 
			}

			it "elimina la encuesta indicada" do
				expect{
					delete api_v1_poll_path(@poll), params: { token: @token.token }
					}.to change(MyPoll, :count).by(-1)
			end
		end

		context "con un token inválido" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: FactoryGirl.create(:dummy_user))
				delete api_v1_poll_path(@poll), params: { token: @token.token }
			end
			it{ expect(response).to have_http_status(401) }
		end
	end
end