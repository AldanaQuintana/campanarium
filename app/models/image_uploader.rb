class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  include Sprockets::Rails::Helper

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end
