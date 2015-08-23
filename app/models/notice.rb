class Notice < ActiveRecord::Base

  has_many :media, class_name: :Media
  belongs_to :notice_group

  def images_urls
    media.map{|m| m.image_url}
  end
end
