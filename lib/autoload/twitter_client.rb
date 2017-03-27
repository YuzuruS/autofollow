class TwitterClient
  attr_reader :client

  MAX_NUM_OF_FRIENDS   = 5000
  MAX_NUM_OF_FOLLOWERS = 5000
  OFFICIAL_ACCOUNT_ID  = 'autofollow0218'

  def initialize(access_token, access_token_secret)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["DEV_TWITTER_API_KEY"]
      config.consumer_secret = ENV["DEV_TWITTER_API_SECRET"]
      config.access_token = access_token
      config.access_token_secret = access_token_secret
    end
  end

  def has_too_many_friends?
    client.user.friends_count >= MAX_NUM_OF_FRIENDS
  end

  def has_too_many_followers?
    client.user.followers_count >= MAX_NUM_OF_FOLLOWERS
  end

  def follow_official_account!
    client.follow(OFFICIAL_ACCOUNT_ID)
  end
end
