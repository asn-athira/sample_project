class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def client_mail
    user = self
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = tUser.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        fullname = data['name'].split(' ')
        first_name, last_name = fullname[0], fullname[1]
        user = User.create(
          provider:access_token.provider,
          email: data["email"],
          uid: access_token.uid ,
          encrypted_password: Devise.friendly_token[0,20],
        )
      end
    end
  end

  def self.create_or_fetch_google_user(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        fullname = data['name'].split(' ')
        first_name, last_name = fullname[0], fullname[1]
        user = User.create(email: data["email"],
          provider:access_token.provider,
          uid: access_token.uid ,
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end

  def self.create_or_fetch_fb_user(auth)
      email = auth.info.email
      names = auth.info.name.split(' ')
      if names.size > 1
        first_name = names[0..-2].join(' ')
        last_name = names[-2]
      else
        first_name = auth.info.name
        last_name = ''
      end

      # Check if the user with this email id has previously registered using our registered form or with google
      # If so, just convert the user to facebook user
      user = User.where(email: email).first
      if user
        case user.provider
        when nil
          user.provider = auth.provider
          user.uid = auth.uid
        when "facebook"
          if user.uid == auth.uid
            user.email = email
          else
            user.uid = auth.uid
          end
        when "google"
          user.provider = auth.provider
          user.uid = auth.uid
        end
      else
        # The user doesn't exist. 
        # So create a new user with provider = "facebook" and with fb uid
        user = User.new
        user.email = email
        user.encrypted_password = Devise.friendly_token[0,20]
        user.provider = auth.provider
        user.uid = auth.uid
      end

      # Setting Defaults
      
      # Saving the User (This will update the user first name and last name in case if the user has changed it in facebook)
      user.save
      
      # user = ClientUser.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      #   user.email = email
      #   user.password = Devise.friendly_token[0,20] unless user.password
      #   user.first_name = first_name
      #   user.last_name = last_name
      #   user.mobile_number = '' unless user.mobile_number
      #   user.organisation = ''
      #   user.country = ''
      #   # TODO - Copy Image to Avatar Later
      #   #user.image = auth.info.image # assuming the user model has an image
      # end
      return user

    end
end
