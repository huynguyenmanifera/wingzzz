require 'rails_helper'

RSpec.describe SectionedForm::SubscriptionAndBillingDetailsComponent,
               type: :component do
  subject { Capybara.string(html) }

  let(:html) { render_inline(instance) }
  let(:instance) { described_class.new(options) }
  let(:options) { { user: user } }

  describe 'without subscription' do
    let(:user) { create(:user, subscription: nil) }

    it { is_expected.to have_content('No subscription and billing info found') }
  end

  describe 'without mandate' do
    before { allow(user).to receive(:mollie_mandate).and_return(nil) }
    let(:user) { create(:user) }

    it { is_expected.to have_content('No subscription and billing info found') }
  end
end
