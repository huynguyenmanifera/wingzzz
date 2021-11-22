require 'rails_helper'
require 'book_storage/local'

RSpec.describe BookStorage::Local do
  let(:book) { build :book, slug: 'my-book' }

  describe '.epub_url' do
    context 'when local directory exists' do
      before { allow(instance).to receive(:root).and_return(root_double) }

      subject { instance.epub_url }

      let(:instance) { described_class.new(book) }
      let(:root_double) { Rails.root }

      it { is_expected.to eql('/tmp/uploads/book/epub/my-book/') }
    end

    context 'when local directory does not exist' do
      subject { described_class.new(book).epub_url }

      it { is_expected.to be_nil }
    end
  end
end
