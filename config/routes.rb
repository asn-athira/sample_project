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
    end
 	end 

end
