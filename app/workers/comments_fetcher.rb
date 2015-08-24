class CommentsFetcher < ResqueJob

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_KEY"]
      config.consumer_secret     = ENV["TWITTER_SECRET"]
      config.access_token        = ENV["TWITTER_TOKEN"]
      config.access_token_secret = ENV["TWITTER_TOKEN_SECRET"]
    end
  end

  def search_and_persist str
    tweets = client.search(str).attrs[:statuses]
    tweets.each do |tweet|
      message = tweet[:text]
      username = tweet[:user][:screen_name]
      uuid = tweet[:id_str]
      puts "Twitter comment found (#{uuid}): #{username} says '#{message}'"
      Comment.create uuid: uuid, message: message, username: username, source: :twitter
    end
  end

end
