Rails.application.routes.draw do

  devise_for :users

  root 'home#index'
  resources :sendgrid_mail do
		collection do
   		get :document
    end
 	end 
 	resources :sendgrid_devise do
		collection do
   		get :document
   		get :home
    end
 	end 
#	devise_for :users, path: "user", path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'settings' },:controllers => { :omniauth_callbacks => "omniauth_callbacks" } do
#	    get '/user/auth/:provider' => 'omniauth_callbacks#passthru'
#	 end
end
