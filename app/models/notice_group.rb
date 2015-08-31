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
end