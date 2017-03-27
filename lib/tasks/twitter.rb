class Tasks::Twitter
  def self.execute
    delete_users = []
    User.where(provider: 'twitter').find_each {|user|
      twitter_client = TwitterClient.new(user.access_token, user.access_token_secret)
      if twitter_client.has_too_many_followers? || twitter_client.has_too_many_friends?
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
    if delete_users.present?
      User.destroy(delete_users)
    end
  end
end
