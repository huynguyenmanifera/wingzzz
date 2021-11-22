require 'rails_helper'

RSpec.describe Admin::EpubsController, type: :controller do
  include ActionDispatch::TestProcess::FixtureFile

  before { sign_in create(:user, admin: true) }

  describe '#edit' do
    let(:book) { create :book }

    def do_get_edit
      get :edit, params: { book_id: book.id }
    end

    it do
      do_get_edit
      expect(assigns(:book)).to eq(book)
    end

    it { expect(response).to have_http_status(200) }
  end

  describe '#update' do
    let(:file) { fixture_file_upload('epub/epub_test.zip', 'application/zip') }
    let(:book) { create :book }
    let(:storage) { book.storage }

    def do_post
      post :update, params: { book_id: book.id, epub: { file: file } }
    end

    it do
      expect(EpubExtractor).to receive(:extract_epub)
      do_post
    end

    it { expect(response).to have_http_status(200) }
  end
end
