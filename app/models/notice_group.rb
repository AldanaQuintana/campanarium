class NoticeGroup < ActiveRecord::Base
  has_many :notices
  has_many :comments, dependent: :destroy
  has_one :comments_statistic_image, as: :media_owner, class_name: Media


  after_create :calculate_best_keyword!

  def comments_statistic_image_url
    comments_statistic_image.try(:url)
  end

  def comments_statistic_image
    # TODO: Delete this, temporary implementation
    return true
  end

  def calculate_best_keyword!
    words = notices.pluck(:keywords).reject(&:empty?).flatten
    kw = words.reduce{|memo, word| words.count(memo) > words.count(word) ? memo : word }
    self.update_attributes(best_keyword: kw)
    kw
  end

  class << self
    def without_comments
      self.joins("left join comments on notice_groups.id = comments.notice_group_id").group("notice_groups.id").having("count(notice_group_id) = 0")
    end

    def with_keyword
      self.where.not(best_keyword: nil)
    end
  end
end