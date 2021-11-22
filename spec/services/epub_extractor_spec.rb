require 'rails_helper'

RSpec.describe EpubExtractor do
  let(:book) { build :book }
  let(:storage) { book.storage }
  let(:zip_file) do
    fixture_file_upload('epub/epub_test.zip', 'application/zip')
  end

  describe '#extract_epub' do
    it 'deletes old files' do
      expect(storage).to receive(:delete_epub_files!)
      EpubExtractor.extract_epub(storage, zip_file)
    end

    it 'adds extracted files in zip' do
      storage = spy(storage)
      allow(book).to receive(:storage).and_return(storage)

      EpubExtractor.extract_epub(storage, zip_file)

      expect(storage).to have_received(:add_epub_file!).with(
        anything,
        'META-INF/container.xml'
      )
        .once

      expect(storage).to have_received(:add_epub_file!).with(
        anything,
        'OPS/images/cover-image.png'
      )
        .once
    end
  end
end
