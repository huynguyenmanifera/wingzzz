require 'rails_helper'

RSpec.describe Account::SettingsController, type: :controller do
  describe '#edit' do
    let(:user) { create :user, :with_an_active_subscription }

    before do
      sign_in user
      get :edit
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe '#update' do
    let(:user) { create :user, :with_an_active_subscription, locale: 'en' }

    before { sign_in user }

    def do_post
      post :update, params: { user: { locale: 'nl' } }
    end

    it do
      expect { do_post }.to change { user.reload.locale }.from('en').to('nl')
    end

    it { expect(do_post).to redirect_to(account_path) }
  end
end
