Rails.application.routes.draw do
  # get "/", to: "welcome#root"

  namespace :api do
  	namespace :v1 do
  		resources :users #, only: [:create]
  	end
  end
end
