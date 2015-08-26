class Media < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :media_owner, polymorphic: true
end
