require 'rails_helper'

RSpec.describe Admin::BooksController, type: :controller do
  describe 'authorization' do
    before do
      sign_in signed_in_user if defined?(signed_in_user)
      get :index
    end

    context 'when logged in as admin' do
      let(:signed_in_user) { create :user, admin: true }
      it { expect(response.status).to eq(200) }
    end

    context 'when logged in as regular user' do
      let(:signed_in_user) { create :user, admin: false }
      it { expect(response).to redirect_to('/') }
    end

    context 'when not logged in' do
      it { expect(response).to redirect_to('/users/sign_in') }
    end
  end
end
