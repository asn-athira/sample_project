class SendgridMailController < ApplicationController
  layout 'sendgrid_mail'

	def index
  	@page_title = "Sendgrid Mailer"	
	end

	def document
	end

	def new
    @email=Email.new
	end
	
	def create
		get_email
		send_welcome_email
		flash[:notice] = 'Email sent successfully ! Please Check Your Email Account '
		redirect_to new_sendgrid_mail_path
  end

	def get_mail
		get_params	
	end

	private
	def email_params
    params.require(:email).permit(:email)
	end

	def get_email
		@user=Email.new(email_params)
    @user_email=email_params[:email]
	end

	def send_welcome_email
    SendgridMailerNotification.send_welcome_email(@user_email).deliver
  end

end