class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, :omniauth_providers => [:twitter, :google, :facebook]

  has_many :identities

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      user.email    = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  # TODO: move all this into oauthable concern

  def twitter
    identities.where(provider: 'twitter').first
  end

  def twitter_client
    @twitter_client ||= Twitter.client(access_token: twitter.accesstoken)
  end

  def facebook
    identities.where(provider: 'facebook').first
  end

  def facebook_client
    @facebook_client ||= Facebook.client(access_token: facebook.accesstoken)
  end

  def google_oauth2
    identities.where(provider: 'google_oauth2').first
  end

  def google_oauth2_client
    if !@google_oauth2_client
      # TODO: clean this up
      @google_oauth2_client = Google::APIClient.new(application_name: 'Dactyl', application_version: '1.0.0' )
      @google_oauth2_client.authorization.update_token!({ access_token: google_oauth2.accesstoken, refresh_token: google_oauth2.refreshtoken })
    end
    @google_oauth2_client
  end

end
