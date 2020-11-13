# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => 'apikey',
  :password => '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',
  
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}