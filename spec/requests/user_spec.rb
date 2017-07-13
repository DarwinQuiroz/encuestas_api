require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
	describe "POST /users" do
		before :each do
			auth = {provider: "github", uid:"34567", info: {email: "user@mail.com"} }
			post "/api/v1/users", params: { auth: auth }
		end

		it{ have_http_status(200) }
		it { change(User, :count).by(1) }

		it "deberia responder con el usuario encotrado o creado" do
			json = JSON.parse(response.body)
			# puts "\n\n\n --- #{json} ---- \n\n\n"
			expect(json["email"]).to eq("user@mail.com")
		end
	end
end