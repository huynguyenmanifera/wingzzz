class BookAudioUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.slug}"
  end

  def extension_whitelist
    %w[mp3]
  end

  def size_range
    0...50.megabytes
  end

  def filename
    'original.mp3' if original_filename
  end
end
