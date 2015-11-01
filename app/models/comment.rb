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

  def self.unique_contents
    # esto se podria mejorar?
    # la idea es agarrar tweets con contenido unico ("simplificar" retweets)
    uuids = select(:parent_uuid).group(:parent_uuid).pluck :parent_uuid
    uuids.map do |uuid|
      comments = where parent_uuid: uuid
      uuid ? comments.first : comments
    end.flatten
  end

end
