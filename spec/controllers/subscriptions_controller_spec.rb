require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  before do
    basic_auth(*Wingzzz.config.admin.values)
    sign_in user

    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:subscribe).and_return(subscription_stub)
  end

  let(:subscription_stub) do
    double('Subscription', active?: false, checkout_url: checkout_url)
  end
  let(:checkout_url) { 'http://mollie.checkout.com' }
  let(:user) { create(:user, :in_trial_period).decorate }

  describe 'GET /new' do
    render_views

    it 'clears the flash' do
      flash_hash = ActionDispatch::Flash::FlashHash.new(info: 'Something')
      session['flash'] = flash_hash.to_session_value

      get :new
      expect(response.body).not_to include('Something')
    end

    context 'user with initialized subscription' do
      let(:user) { create(:user, :with_an_initialized_subscription).decorate }

      it 'warns the subscription is not yet activated' do
        get :new
        expect(response.body).to include(
          I18n.t('subscription_not_yet_activated')
        )
      end
    end
  end

  describe 'POST /create' do
    def do_post
      post :create
    end

    it 'has the user subscribed' do
      expect(user).to receive(:subscribe)
      do_post
    end

    it 'redirects the user to the Mollie checkout page' do
      expect(do_post).to redirect_to(checkout_url)
    end
  end

  describe 'GET /show' do
    describe 'signed in' do
      def do_get
        get :show
      end

      describe 'without a subscription' do
        describe 'with an active trial' do
          let(:user) { create(:user, :in_trial_period) }

          it 'needs to setup the subscription first' do
            expect(do_get).to redirect_to(root_url)
          end
        end

        describe 'with an expired trial' do
          let(:user) { create(:user, :with_expired_trial) }

          it 'needs to setup the subscription first' do
            expect(do_get).to redirect_to(root_url)
          end
        end
      end

      describe 'with an active subscription' do
        let(:user) { create(:user, :with_an_active_subscription) }

        it 'redirects to the root' do
          expect(do_get).to redirect_to(root_path)
        end
      end
    end
  end
end
