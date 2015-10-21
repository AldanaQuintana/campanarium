class NoticeGroup < ActiveRecord::Base
  has_many :notices
  has_many :comments
  has_one :comments_statistic_image, as: :media_owner, class_name: Media

  def comments_statistic_image_url
    comments_statistic_image.try(:url)
  end

  def comments_statistic_image
    # TODO: Delete this, temporary implementation
    return true
  end

  def best_keyword
    words = notices.pluck(:keywords).reject(&:empty?).flatten
    words.max{|w| words.count(w)} || words.first
  end

  class << self
    def without_comments
      self.joins("left join comments on notice_groups.id = comments.notice_group_id").group("notice_groups.id").having("count(notice_group_id) = 0")
    end
  end
end