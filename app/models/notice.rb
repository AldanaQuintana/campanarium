class Notice < ActiveRecord::Base
  has_many :media, as: :media_owner, class_name: Media
  before_destroy :destroy_group_if_empty
  belongs_to :notice_group
  serialize :keywords, Array
  serialize :categories, NoticeCategory

  validates :body, uniqueness: true

  def images_urls
    media.map &:image_url
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
    return unless notice_group
    notice_group.destroy unless notice_group.notices.where("id != ?", self.id).count > 0
  end
end
