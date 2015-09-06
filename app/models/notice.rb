class Notice < ActiveRecord::Base
  has_many :media, as: :media_owner, class_name: Media
  before_destroy :destroy_group_if_empty
  belongs_to :notice_group

  def images_urls
    media.map{|m| m.image_url}
  end

  def has_images?
    images_urls.reject(&:nil?).length > 0
  end

  def unlink!
    self.destroy_group_if_empty
    self.notice_group_id = nil
    self.save
  end

  def destroy_group_if_empty
    notice_group.destroy unless notice_group.notices.where("id != ?", self.id).count > 0
  end
end
