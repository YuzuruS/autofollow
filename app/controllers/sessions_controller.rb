class SessionsController < ApplicationController
  def create
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    logger.debug(user)
    if user.blank?
      redirect_to root_path, notice: 'エラーがあるよ'
    else
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Registration Successful!'
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしたよ'
  end
end
