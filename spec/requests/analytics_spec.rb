require 'rails_helper'

RSpec.describe 'analytics', type: :request do
  it 'renders a GTM tag' do
    get root_path
    follow_redirect!

    expect(response.body).to include('gtm.js')
  end

  context 'with logged in user' do
    let(:user) { create :user, :with_an_active_subscription }

    before { sign_in user }

    it 'includes user data on the GTM dataLayer' do
      get root_path

      # rubocop:disable Layout/HeredocIndentation
      expect(response.body).to include(
        <<~JS
        dataLayer.push({"language":"#{user.locale}","userId":#{
          user.id
        },"subscriptionStatus":"active"})
      JS
          .strip
      )
      # rubocop:enable Layout/HeredocIndentation
    end
  end

  context 'without logged in user' do
    it 'does not include user data' do
      get root_path
      follow_redirect!

      # rubocop:disable Layout/HeredocIndentation
      expect(response.body).to include(
        <<~JS
        dataLayer.push({"language":"en","userId":null,"subscriptionStatus":"unknown"})
      JS
          .strip
      )
      # rubocop:enable Layout/HeredocIndentation
    end
  end
end
