require 'rails_helper'

RSpec.describe Trials do
  describe '.start' do
    before { allow(UserMailer).to receive(:with).and_return(mailer_stub) }

    subject { described_class.start(user) }

    let(:trial) { user.trial }
    let(:trial_duration) { Wingzzz.config.trial[:duration_in_days] }
    let(:today) { Date.current }
    let(:mailer_stub) { double('Mailer', welcome_email: message_delivery_stub) }
    let(:message_delivery_stub) do
      double('MessageDelivery', deliver_later: nil)
    end

    describe 'with user not in trial' do
      let!(:user) { create(:user) }

      it 'registers the end of the trial' do
        subject
        expect(trial.expires_after).to eq(
          trial_duration.days.from_now(Date.yesterday)
        )
      end

      it 'attaches the trial to the user' do
        expect { subject }.to change(user, :trial)
      end

      it 'sends a welcome email' do
        expect(UserMailer).to receive(:with).with(user: user).and_return(
          mailer_stub
        )
        expect(message_delivery_stub).to receive(:deliver_later)

        subject
      end
    end

    describe 'with user in trial' do
      let!(:user) { create(:user, :in_trial_period) }

      it 'does not attach the trial to the user' do
        expect { subject }.not_to change(user, :trial)
      end

      it 'does not send a welcome email' do
        expect(UserMailer).not_to receive(:with).with(user: user)

        subject
      end
    end

    describe 'with an invalid user' do
      let!(:user) { build(:user, email: 'invalid') }

      it 'does not attach the trial to the user' do
        expect { subject }.not_to change(user, :trial)
      end

      it 'does not send a welcome email' do
        expect(UserMailer).not_to receive(:with).with(user: user)

        subject
      end
    end
  end
end
