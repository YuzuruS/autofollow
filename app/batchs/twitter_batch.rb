class TwitterBatch
  def self.execute
    delete_users = []
    User.where(provider: 'twitter').find_each {|user|
      twitter_client = TwitterClient.new(user.access_token, user.access_token_secret)
      unless twitter_client.valid?
        delete_users << user
        next
      end

      res = twitter_client.client.friend_ids.to_h
      friend_ids = res[:ids]

      res = twitter_client.client.follower_ids.to_h
      follower_ids = res[:ids]

      diff_friend_ids = follower_ids - friend_ids
      begin
        twitter_client.client.follow(diff_friend_ids)
      rescue => e
        puts e
        delete_users << user
        next
      end
    }
    if delete_users.present?
      User.destroy(delete_users)
    end
  end
end
