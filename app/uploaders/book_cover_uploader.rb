class BookCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.slug}"
  end

  process convert: 'png'

  def extension_whitelist
    %w[jpg jpeg png]
  end

  def size_range
    0...10.megabytes
  end

  def full_filename(for_file)
    return unless (parent_name = super(for_file))

    extension = File.extname(parent_name)
    version_name ? version_name.to_s + extension : 'original.png'
  end

  version :thumbnail do
    process resize_to_fill: [200, 255]
    process convert: 'JPEG'

    def full_filename(file)
      change_filename_extension super(file), 'jpg'
    end
  end

  def default_url(*_args)
    '/images/fallback/' + [version_name, 'default.jpg'].compact.join('_')
  end

  private

  def change_filename_extension(filename, extension)
    basename = File.basename(filename, File.extname(filename))
    "#{basename}.#{extension}"
  end
end
