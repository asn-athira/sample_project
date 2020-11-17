class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = ClientUser.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        fullname = data['name'].split(' ')
        first_name, last_name = fullname[0], fullname[1]
        user = User.create(first_name: first_name,
          last_name: last_name,
          provider:access_token.provider,
          email: data["email"],
          uid: access_token.uid ,
          password: Devise.friendly_token[0,20],
          mobile_number: 123455678
        )
      end
    end
  end
end
