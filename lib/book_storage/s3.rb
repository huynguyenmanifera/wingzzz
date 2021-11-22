require_relative 'base'

module BookStorage
  class S3 < Base
    def epub_url
      url epub_path, trailing_slash: true
    end

    def delete_epub_files!
      s3_bucket.objects(prefix: epub_path).batch_delete!
    end

    def add_epub_file!(source_path, relative_target_path)
      target_path = File.join(epub_path, relative_target_path)
      s3_bucket.object(target_path).upload_file source_path
    end

    private

    def url(path, props = {})
      uri = URI(Rails.application.routes.url_helpers.s3_file_path(path, props))
      uri.query = nil
      uri.to_s
    end

    def s3_bucket
      @s3_bucket ||=
        Aws::S3::Resource.new(region: Wingzzz.config.s3[:region]).bucket(
          Wingzzz.config.s3[:bucket_name]
        )
    end
  end
end
