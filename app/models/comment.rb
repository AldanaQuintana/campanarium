class Comment < ActiveRecord::Base
  belongs_to :notice_group

  def url
    "https://twitter.com/#{username}/status/#{uuid}" if source == 'twitter'
  end

end
