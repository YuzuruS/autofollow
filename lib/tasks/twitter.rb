class Tasks::Twitter
  def self.execute
    delete_users = []
    User.where(:provider => 'twitter').find_each{|user|
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["DEV_TWITTER_API_KEY"]
        config.consumer_secret     = ENV["DEV_TWITTER_API_SECRET"]
        config.access_token        = user.access_token
        config.access_token_secret = user.access_token_secret
      end
      if client.user.followers_count  >= 5000 || client.user.friends_count >= 5000
        delete_users << user
        next
      end

      res = client.send(:friend_ids).to_h
      friend_ids = res[:ids]

      res = client.send(:follower_ids).to_h
      follower_ids = res[:ids]

      diff_friend_ids = follower_ids - friend_ids
      client.follow(diff_friend_ids)
    }
    User.destroy(delete_users)
  end
end