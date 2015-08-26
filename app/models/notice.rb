class Notice < ActiveRecord::Base

  has_many :media, as: :media_owner, class_name: Media
  belongs_to :notice_group

  def images_urls
    media.map{|m| m.image_url}
  end

  def has_images?
    images_urls.reject(&:nil?).length > 0
  end
end
