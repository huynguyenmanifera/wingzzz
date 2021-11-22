require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  describe 'PUT #update' do
    let(:user) { create(:user, :with_an_active_subscription) }
    let(:profile) { user.profiles.first }

    before do
      basic_auth(*Wingzzz.config.admin.values)
      sign_in user
    end

    def do_put(params)
      put :update, params: params
    end

    it 'updates min_age_in_months' do
      expect { do_put(profile: { min_age_in_months: 99 }) }.to change {
        profile.reload.min_age_in_months
      }.to(99)
    end

    it 'updates max_age_in_months' do
      expect { do_put(profile: { max_age_in_months: 88 }) }.to change {
        profile.reload.max_age_in_months
      }.to(88)
    end

    it 'updates content_language' do
      expect { do_put(profile: { content_language: 'nl' }) }.to change {
        profile.reload.content_language
      }.to('nl')
    end

    context 'when reset is true' do
      let(:profile) do
        create :profile,
               content_language: 'hu',
               min_age_in_months: 12,
               max_age_in_months: 36
      end

      let(:user) do
        create(:user, :with_an_active_subscription, profiles: [profile])
      end

      before { allow(I18n).to receive(:locale).and_return('nl') }

      def do_put
        put :update, params: { reset: 'lorem' }
      end

      it 'sets content_language to current locale' do
        expect { do_put }.to change { profile.reload.content_language }.to('nl')
      end

      it 'sets min_age_in_months to nil' do
        expect { do_put }.to change { profile.reload.min_age_in_months }.to(nil)
      end

      it 'sets max_age_in_months to nil' do
        expect { do_put }.to change { profile.reload.max_age_in_months }.to(nil)
      end
    end
  end
end
