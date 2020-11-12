Rails.application.routes.draw do

  root 'home#index'
  resources :sendgrid_mail do
		collection do
   		get :document
    end
 end 

end
