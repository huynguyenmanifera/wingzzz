require 'rails_helper'

RSpec.describe Webhooks::MollieController, type: :controller do
  describe 'POST /payment' do
    let(:payment_id) { 'payment_id' }

    def do_post
      post :payment, params: { id: payment_id }
    end

    describe 'no subscription' do
      before do
        allow(Subscription).to receive(:find_by_mollie_payment!).and_raise(
          ActiveRecord::RecordNotFound.new
        )
      end

      it 'returns a response w/o content' do
        do_post
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'with subscription' do
      before do
        allow(Subscription).to receive(:find_by_mollie_payment!).and_return(
          subscription
        )
        allow(subscription).to receive(:may_activate?).and_return(may_activate)
        allow(subscription).to receive(:activate!)
        allow(subscription).to receive(:payment_canceled?).and_return(
          payment_canceled
        )
      end

      let(:user) { create(:user, :with_a_pending_subscription) }
      let(:subscription) { user.subscription }

      describe 'may be activated' do
        let(:may_activate) { true }
        let(:payment_canceled) { false }

        it 'activates the subscription' do
          expect(subscription).to receive(:activate!)
          do_post
        end

        it 'returns a response w/o content' do
          do_post
          expect(response).to have_http_status(:ok)
        end
      end

      describe 'may not be activated' do
        let(:may_activate) { false }
        let(:payment_canceled) { false }

        it 'does not activate the subscription' do
          expect(subscription).not_to receive(:activate!)
          do_post
        end

        it 'returns a response w/o content' do
          do_post
          expect(response).to have_http_status(:ok)
        end
      end

      describe 'payment canceled' do
        let(:may_activate) { false }
        let(:payment_canceled) { true }

        it 'destroys the subscription' do
          expect(subscription).to receive(:destroy!)
          do_post
        end
      end
    end

    describe 'something went wrong'
  end

  describe 'GET /pay' do
    before do
      allow(Subscription).to receive(:find_by).and_return(subscription)
      allow(subscription).to receive(:may_pend?).and_return(may_pend)
      allow(subscription).to receive(:pend!)
    end

    let(:user) { create(:user, :with_an_initialized_subscription) }
    let(:subscription) { user.subscription }
    let(:token) { subscription.token }

    def do_get
      get :pay, params: { token: token }
    end

    describe 'may pend' do
      let(:may_pend) { true }

      it 'pends the subscription' do
        expect(subscription).to receive(:pend!)
        do_get
      end

      it 'redirects to the home page' do
        expect(do_get).to redirect_to(root_url)
      end
    end

    describe 'may not pend' do
      let(:may_pend) { false }

      it 'does not pend the subscription' do
        expect(subscription).not_to receive(:pend!)
        do_get
      end

      it 'redirects to the home page' do
        expect(do_get).to redirect_to(root_url)
      end
    end
  end

  describe 'POST /subscription' do
    def do_post
      post :subscription
    end

    it 'returns a response w/o content' do
      do_post
      expect(response).to have_http_status(:ok)
    end
  end
end
