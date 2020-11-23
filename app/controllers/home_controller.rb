class HomeController < ApplicationController
    layout 'home'

	def index	
  	@page_title = "Home"
	end
end