Rails.application.routes.draw do
  # get "/", to: "welcome#root"

  namespace :api do
  	namespace :v1 do
  		resources :users, only: [:create]
  		resources :polls, controller: "my_polls", except: [:new, :edit] do
  			resources :questions, except: [:new, :edit]
  			resources :answers, only: [:create, :update, :destroy]
  		end
  	end
  end
end
