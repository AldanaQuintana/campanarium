class Comment < ActiveRecord::Base
  belongs_to :notice_group

  def url
    "https://twitter.com/#{username}/status/#{uuid}" if source == 'twitter'
  end

  def set_polarity(polarity)
    update_attributes(
      :polarity => polarity,
      :positivity => polarity == 0 ? 'neutral' : polarity < 0 ? 'negative' : 'positive'
    )
  end
end
