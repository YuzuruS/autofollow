class MyTwitter
  #TODO 外部ライブラリを読み込む方法
  def client(current_user)
    Twitter::REST::Client.new do |config|
      config.consumer_key        = current_user.token
      config.consumer_secret     = current_user.secret
      config.access_token        = "YOUR_ACCESS_TOKEN"
      config.access_token_secret = "YOUR_ACCESS_SECRET"
    end
  end
end