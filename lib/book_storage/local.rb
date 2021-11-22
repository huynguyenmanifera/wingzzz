require_relative 'base'

module BookStorage
  class Local < Base
    def epub_url
      return unless root.exist?

      "#{CarrierWave::Uploader::Base.base_path}/#{epub_path}/"
    end

    def delete_epub_files!
      root.rmtree if root.exist?
    end

    def add_epub_file!(source_path, relative_target_path)
      target_path = root.join(relative_target_path)
      target_path.dirname.mkpath

      FileUtils.cp source_path, target_path
    end

    def root
      Pathname.new(CarrierWave::Uploader::Base.root.call).join(epub_path)
    end
  end
end
