require 'rails_helper'

RSpec.describe S3FilesController, type: :controller do
  describe 'GET #show' do
    before do
      allow(PresignedUrlCreator).to receive(:presigned_url).and_return(
        presigned_url
      )
    end

    let(:presigned_url) { 'presigned_url' }

    def do_get
      get :show, params: { key: 'lorem/ipsum' }, format: :xml
    end

    context 'when authenticated' do
      before { sign_in FactoryBot.create(:user) }
      it 'redirects to presigned url' do
        do_get
        expect(response).to redirect_to(presigned_url)
      end
    end

    context 'when not authenticated' do
      it 'results in unauthorized response code' do
        do_get
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
