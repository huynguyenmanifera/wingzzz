class PresignedUrlCreator
  EXPIRES_IN = 5.minutes

  def self.presigned_url(params)
    new(params).send(:presigned_url)
  end

  private

  attr_reader :params
  delegate :s3, to: 'Wingzzz.config'

  def initialize(params)
    @params = params
  end

  def presigned_url
    signer.presigned_url(
      :get_object,
      bucket: bucket_name, key: key, expires_in: EXPIRES_IN.to_i
    )
  end

  def signer
    Aws::S3::Presigner.new(client: client)
  end

  def key
    "#{params[:key]}.#{params[:format]}"
  end

  def client
    Aws::S3::Client.new(
      region: region,
      access_key_id: access_key_id,
      secret_access_key: secret_access_key
    )
  end

  %i[region bucket_name access_key_id secret_access_key].each do |symbol|
    define_method(symbol) { s3[symbol] }
  end
end
