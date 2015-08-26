class Comment < ActiveRecord::Base

  def url
    "twitter.com/#{username}/status/#{uuid}" if source == 'twitter'
  end

end
