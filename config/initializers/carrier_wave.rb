CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Wingzzz.config.s3[:access_key_id],
    aws_secret_access_key: Wingzzz.config.s3[:secret_access_key],
    region: Wingzzz.config.s3[:region]
  }

  config.fog_directory = Wingzzz.config.s3[:bucket_name]
  config.fog_public = false
  config.storage = Wingzzz.config.books[:storage] == 'S3' ? :fog : :file

  if Rails.env.test?
    config.enable_processing = false
    config.root = -> { Rails.public_path.join('tmp') }
    config.base_path = '/tmp'
  end
end
