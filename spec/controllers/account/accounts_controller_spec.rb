require 'rails_helper'

RSpec.describe Account::AccountsController, type: :controller do
  describe '#show' do
    let(:user) { create :user, :with_an_active_subscription }

    before do
      sign_in user
      get :show
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /unsubscribe' do
    before do
      sign_in user

      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:unsubscribe)
    end

    let(:user) { create :user, :with_an_active_subscription }
    let(:mailer_stub) do
      double('Mailer', unsubscribe_email: message_delivery_stub)
    end
    let(:message_delivery_stub) do
      double('MessageDelivery', deliver_later: nil)
    end

    def do_post
      post :unsubscribe
    end

    it 'unsubscribes the current user' do
      expect(user).to receive(:unsubscribe)
      do_post
    end

    it 'sends a mail to the user' do
      expect(UserMailer).to receive(:with).with(user: user).and_return(
        mailer_stub
      )
      expect(message_delivery_stub).to receive(:deliver_later)
      do_post
    end

    it 'redirects to the show page' do
      expect(do_post).to redirect_to(account_url)
    end
  end
end
