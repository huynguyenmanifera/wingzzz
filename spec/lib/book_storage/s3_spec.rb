require 'rails_helper'
require 'book_storage/s3'

RSpec.describe BookStorage::S3 do
  let(:book) { build :book, slug: 'my-book' }

  describe '.epub_url' do
    subject { described_class.new(book).epub_url }

    it { is_expected.to eql('/s3_files/uploads/book/epub/my-book/') }
  end
end
