class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [1440, 1440]

  version :small do
    process resize_to_fit: [360, 360]
  end

  version :challenge do
    process resize_to_fit: [550, 550]
  end

  version :feature do
    process resize_to_fit: [960, 960]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
