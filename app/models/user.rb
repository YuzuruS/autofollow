class User < ApplicationRecord
  validates :provider, presence: true
  validates :uid, presence: true
  validates :nickname, presence: true
  validates :image_url, presence: true
  validates :email, presence: true
  validates :access_token, presence: true
  validates :access_token_secret, presence: true


  def self.find_or_create_from_auth_hash(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    nickname = auth_hash[:info][:nickname]
    image_url = auth_hash[:info][:image]
    email = auth_hash[:info][:email]
    access_token = auth_hash[:credentials][:token]
    access_token_secret = auth_hash[:credentials][:secret]
    @user = User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.nickname = nickname
      user.image_url = image_url
      user.email = email
      user.access_token = access_token
      user.access_token_secret = access_token_secret
    end
  rescue ActiveRecord::RecordInvalid
    @user
  end
end