class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    user = User.find_by(provider: auth_hash[:provider], uid: auth_hash[:uid])
    if user.present?
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました'
    else
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["DEV_TWITTER_API_KEY"]
        config.consumer_secret     = ENV["DEV_TWITTER_API_SECRET"]
        config.access_token = auth_hash[:credentials][:token]
        config.access_token_secret = auth_hash[:credentials][:secret]
      end
      client.follow('autofollow0218')
      if client.user.friends_count >= 5000
        redirect_to root_path, notice: '5000以上フォローがいる場合このツールは使用できません'
      elsif client.user.followers_count >= 5000
        redirect_to root_path, notice: '5000以上フォロアーがいる場合このツールは使用できません'
      end
      user = User.create_from_auth_hash(auth_hash)
      if user.valid?
          session[:user_id] = user.id
          redirect_to root_path, notice: '登録完了しました'
      else
        redirect_to root_path, alert: user.errors.full_messages
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました'
  end
end
