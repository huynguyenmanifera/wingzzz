require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe BookCoverUploader do
  include CarrierWave::Test::Matchers

  let(:book) { build :book }
  let(:uploader) { BookCoverUploader.new(book, :cover) }
  let(:image_path) { 'spec/fixtures/cover/image.png' }

  def upload_file
    File.open(image_path) { |f| uploader.store!(f) }
  end

  before { BookCoverUploader.enable_processing = true }
  after do
    BookCoverUploader.enable_processing = false
    uploader.remove!
  end

  context 'supported image type' do
    before { upload_file }

    describe 'original' do
      subject { uploader }

      it { is_expected.to be_format('png') }
      it { is_expected.to have_permissions(0o644) }

      context 'jpg' do
        let(:image_path) { 'spec/fixtures/cover/image.jpg' }

        it 'is converted to png' do
          is_expected.to be_format('png')
        end
      end

      describe 'filename' do
        subject { uploader.file.filename }
        it { is_expected.to eq('original.png') }
      end
    end

    describe 'thumbnail' do
      subject { uploader.thumbnail }

      it { is_expected.to have_dimensions(200, 255) }
      it { is_expected.to be_format('jpeg') }
      it { is_expected.to have_permissions(0o644) }

      describe 'filename' do
        subject { uploader.thumbnail.file.filename }

        it { is_expected.to eq('thumbnail.jpg') }
      end
    end
  end

  context 'unsupported image type' do
    let(:image_path) { 'spec/fixtures/cover/image.gif' }

    it { expect { upload_file }.to raise_error(CarrierWave::IntegrityError) }
  end
end
