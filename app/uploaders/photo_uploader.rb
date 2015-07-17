class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [1500, 1500]

  version :small do
    process resize_to_fit: [300, 300]
  end

  version :challenge do
    process resize_to_fit: [750, 750]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
