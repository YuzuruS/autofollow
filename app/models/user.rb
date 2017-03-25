class User < ApplicationRecord
  validates :provider, presence: true
  validates :uid, presence: true
  validates :nickname, presence: true
  validates :image_url, presence: true
  validates :email, presence: true
  validates :access_token, presence: true
  validates :access_token_secret, presence: true


  def self.create_from_auth_hash(auth_hash)
    User.create(
      provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      nickname: auth_hash[:info][:nickname],
      image_url: auth_hash[:info][:image],
      email: auth_hash[:info][:email],
      access_token: auth_hash[:credentials][:token],
      access_token_secret: auth_hash[:credentials][:secret]
    )
  end
end