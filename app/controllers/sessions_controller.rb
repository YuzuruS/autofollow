class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    user = User.find_by(provider: auth_hash[:provider], uid: auth_hash[:uid])
    if user.present?
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました'
    else
      @twitter_client = TwitterClient.new(auth_hash[:credentials][:token], auth_hash[:credentials][:secret])
      @twitter_client.follow_official_account!

      unless @twitter_client.valid?
        redirect_to root_path, notice: @twitter_client.errors.full_messages.join(', ')
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

  def retire
    if current_user.destroy
      reset_session
      redirect_to root_path, notice: 'アカウント削除しました'
    else
      redirect_to root_path, alert: 'エラーが発生しました'
    end
  end
end
