class Media < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :notice
end
