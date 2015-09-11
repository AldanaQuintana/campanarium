class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  include Sprockets::Rails::Helper

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :avatar do
    process :resize_to_fill => [120, 120]
  end

  # Nota: crónica tiene urls raras para las imagenes que no pasan esta validacion. Ver qué hay que poner... 
  # def extension_white_list
  #   %w(jpg jpeg gif png JPG JPEG GIF PNG bmp BMP)
  # end
end
