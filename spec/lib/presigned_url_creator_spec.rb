require 'rails_helper'
require 'presigned_url_creator'

RSpec.describe PresignedUrlCreator do
  describe '.presigned_url' do
    before do
      allow(Wingzzz).to receive(:config).and_return(wingzzz_config)
      allow(Aws::S3::Client).to receive(:new).and_return(s3_client_stub)
      allow(Aws::S3::Presigner).to receive(:new).and_return(s3_presigner_stub)
    end

    subject { described_class.presigned_url(params) }

    let(:params) { { key: 'lorem/ipsum', format: :xml } }
    let(:access_key_id) { 'access_key_id' }
    let(:secret_access_key) { 'secret_access_key' }
    let(:region) { 'region' }
    let(:bucket_name) { 'bucket_name' }
    let(:presigned_url) { 'presigned_url' }
    let(:s3_client_stub) { double('Aws::S3::Client') }
    let(:wingzzz_config) { OpenStruct.new(s3: s3_config) }
    let(:s3_config) do
      {
        region: region,
        bucket_name: bucket_name,
        access_key_id: access_key_id,
        secret_access_key: secret_access_key
      }
    end

    let(:s3_presigner_stub) do
      double('Aws::S3::Presigner', presigned_url: presigned_url)
    end

    it 'instantiates an S3 client' do
      expect(Aws::S3::Client).to receive(:new).with(
        secret_access_key: secret_access_key,
        region: region,
        access_key_id: access_key_id
      )
        .and_return(s3_client_stub)

      subject
    end

    it 'instantiates an S3 presigner' do
      expect(Aws::S3::Presigner).to receive(:new).with(client: s3_client_stub)
        .and_return(s3_presigner_stub)

      subject
    end

    it 'queries the S3 presigner for the presigned_url' do
      expect(s3_presigner_stub).to receive(:presigned_url).with(
        :get_object,
        bucket: bucket_name, key: 'lorem/ipsum.xml', expires_in: 300
      )
        .and_return(presigned_url)

      subject
    end
  end
end
