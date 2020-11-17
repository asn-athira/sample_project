class ApplicationController < ActionController::Base

	protected
	def after_sign_in_path_for(resource)
   home_sendgrid_devise_index_path
  end

  def after_sign_out_path_for(resource)
    sendgrid_devise_index_path
  end


end
