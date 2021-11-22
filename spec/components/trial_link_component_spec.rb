require 'rails_helper'

RSpec.describe TrialLinkComponent, type: :component do
  subject { Capybara.string(html) }

  let(:html) { render_inline(instance) }
  let(:instance) { described_class.new(options) }
  let(:options) { { user: user } }
  let(:trial_days_left) { 5 }
  let(:unexpired_trial) do
    build_stubbed(:trial, expires_after: trial_days_left.days.from_now)
  end

  describe 'for an admin' do
    let(:user) { build(:user, :admin) }

    it { expect(subject.text).to be_empty }
  end

  describe 'without a subscription' do
    describe 'with a trial' do
      describe 'that has expired' do
        let(:user) { build_stubbed(:user, :with_expired_trial) }

        it { expect(subject.text).to be_empty }
      end

      describe 'that has not expired' do
        let(:user) { build_stubbed(:user, trial: unexpired_trial) }

        it do
          is_expected.to have_css(
            'a.btn.btn-cta[href$="subscriptions/teacher_options"]',
            text: '6 days left in trial'
          )
        end
      end

      describe 'that expires today' do
        let(:trial_days_left) { 0 }
        let(:user) { build_stubbed(:user, trial: unexpired_trial) }

        it do
          is_expected.to have_css(
            'a.btn.btn-cta[href$="subscriptions/teacher_options"]',
            text: '1 day left in trial'
          )
        end
      end
    end
  end

  describe 'with a subscription' do
    describe 'that is initialized' do
      let(:user) do
        build(:user, :with_an_initialized_subscription, trial: unexpired_trial)
      end

      it do
        is_expected.to have_css(
          'a.btn.btn-cta[href$="subscriptions/teacher_options"]',
          text: '6 days left in trial'
        )
      end
    end

    describe 'that is pending' do
      let(:user) do
        build(:user, :with_a_pending_subscription, trial: unexpired_trial)
      end

      it { expect(subject.text).to be_empty }
    end

    describe 'that is active' do
      let(:user) do
        build(:user, :with_an_active_subscription, trial: unexpired_trial)
      end

      it { expect(subject.text).to be_empty }
    end

    describe 'that is canceled' do
      let(:user) do
        build(:user, :with_a_canceled_subscription, trial: unexpired_trial)
      end

      it { expect(subject.text).to be_empty }
    end
  end
end
