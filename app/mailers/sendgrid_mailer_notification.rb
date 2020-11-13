class SendgridMailerNotification < ApplicationMailer
	def send_welcome_email(user)
   	@email = user
   	mail( :to => @email,
    			:subject => 'Thanks for signing up for our amazing ITS app' )
  end
 end