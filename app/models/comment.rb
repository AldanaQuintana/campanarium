class Comment < ActiveRecord::Base
  belongs_to :notice_group

  def url
    "https://twitter.com/#{username}/status/#{uuid}" if source == 'twitter'
  end

  def set_polarity(polarity)
    update_attribute(:positive, polarity > 0)
  end
end
