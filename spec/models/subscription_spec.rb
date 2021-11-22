require 'rails_helper'

RSpec.describe Subscription, type: :model do
  before do
    allow(Mollie::Payment).to receive(:get).and_return(payment_stub)
    allow(Mollie::Customer::Mandate).to receive(:get).and_return(mandate_stub)
    allow(Mollie::Customer::Subscription).to receive(:create).and_return(
      subscription_stub
    )
    allow(Mollie::Customer::Subscription).to receive(:get).and_return(
      subscription_stub
    )
    allow(Mollie::Customer).to receive(:create).and_return(customer_stub)
    allow(Mollie::Customer).to receive(:get).and_return(customer_stub)
    allow(Mollie::Payment).to receive(:create).and_return(payment_stub)
    allow_any_instance_of(Subscription).to receive(:token).and_return(token)
  end

  let(:payment_stub) do
    double(
      'Mollie::Payment',
      customer_id: mollie_customer_id,
      mandate_id: mandate_id,
      _links: { 'checkout' => { 'href' => checkout_url } },
      metadata: OpenStruct.new(wz_user_id: wz_user_id)
    )
  end
  let(:mollie_customer_id) { 'mollie_customer_id' }
  let(:mandate_id) { 'mandate_id' }
  let(:checkout_url) { 'http://mollie.checkout.com' }
  let(:user) { create(:user, :in_trial_period) }
  let(:mandate_stub) do
    double(
      'Mollie::Customer::Mandate',
      valid?: mandate_valid?, pending?: mandate_pending?
    )
  end
  let(:mandate_valid?) { true }
  let(:mandate_pending?) { false }
  let(:subscription_stub) do
    double(
      'Mollie::Customer::Subscription',
      id: subscription_id, next_payment_date: 14.days.from_now
    )
  end
  let(:customer_stub) { double('Mollie::Customer', id: mollie_customer_id) }
  let(:payment_id) { 'payment_id' }
  let(:redirect_url) { 'http://test.host/webhooks/mollie/pay/token' }
  let(:wz_user_id) { user.id }
  let(:token) { 'token' }
  let(:subscription_id) { 'subscription_id' }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'state machine' do
    subject { subscription }

    let(:subscription) { described_class.new(user: user) }

    it do
      is_expected.to transition_from(:initialized).to(:pending).on_event(:pend)
    end

    it do
      is_expected.to transition_from(:initialized).to(:active).on_event(
        :activate
      )
    end

    it do
      is_expected.to transition_from(:pending).to(:active).on_event(:activate)
    end

    it do
      is_expected.to transition_from(:initialized).to(:initialized).on_event(
        :resubscribe
      )
    end

    it do
      is_expected.to transition_from(:canceled).to(:initialized).on_event(
        :resubscribe
      )
    end
  end

  describe 'initialize' do
    subject { subscription }

    let(:subscription) { described_class.new(user: user) }
    let(:webhook_url) { 'http://test.host/webhooks/mollie/payment' }

    it "creates a user at Mollie's" do
      expect(Mollie::Customer).to receive(:create).with(
        email: user.email, metadata: { wz_user_id: user.id }
      )
      subject
    end

    it "creates a payment at Mollie's" do
      expect(Mollie::Payment).to receive(:create).with(
        amount: { value: '7.99', currency: 'EUR' },
        customerId: mollie_customer_id,
        sequenceType: 'first',
        description: 'Wingzzz first payment',
        redirect_url: redirect_url,
        webhook_url: webhook_url,
        metadata: { wz_user_id: user.id }
      )
      subject
    end

    it 'sets the checkout url' do
      subject
      expect(subscription.checkout_url).to eql(checkout_url)
    end

    it "sets the mollie's customer id" do
      subject
      expect(subscription.mollie_customer_id).to eql(mollie_customer_id)
    end

    it { is_expected.to have_state(:initialized) }
  end

  describe '.cancel' do
    before do
      allow(Mollie::Customer::Subscription).to receive(:delete)
      allow(user).to receive(:mollie_mandate).and_return(mollie_mandate_stub)
    end

    subject { subscription.tap(&:cancel!) }

    let(:subscription) do
      user.subscription.tap do |s|
        s.update(mollie_subscription_id: mollie_subscription_id)
      end
    end
    let(:user) { create(:user, :with_an_active_subscription) }
    let(:mollie_customer_id) { user.mollie_customer_id }
    let(:mollie_subscription_id) { 'mollie_subscription_id' }
    let(:mollie_mandate_stub) { double('mollie_mandate', delete: nil) }

    it 'sets the grace period' do
      expect { subject }.to change(subscription, :grace_period_ends_on)
    end

    it "deletes the Subscription at Mollie's" do
      expect(Mollie::Customer::Subscription).to receive(:delete).with(
        mollie_subscription_id,
        { customer_id: mollie_customer_id }
      )
      subject
    end

    it "delete the Mandate at Mollie's" do
      expect(user.mollie_mandate).to receive(:delete).with(
        customer_id: mollie_customer_id
      )
      subject
    end
  end

  describe '.resubscribe' do
    subject { subscription.tap(&:resubscribe!) }

    let(:subscription) { user.subscription }
    let(:user) { create(:user, :with_a_canceled_subscription) }
    let(:mollie_customer_id) { user.mollie_customer_id }
    let(:webhook_url) { 'http://test.host/webhooks/mollie/payment' }

    it 're-uses the existing Mollie Customer' do
      expect(Mollie::Customer).to receive(:get).with(mollie_customer_id)
      expect(Mollie::Customer).not_to receive(:create)
      subject
    end

    it "creates a payment at Mollie's" do
      expect(Mollie::Payment).to receive(:create).with(
        amount: { value: '7.99', currency: 'EUR' },
        customerId: mollie_customer_id,
        sequenceType: 'first',
        description: 'Wingzzz first payment',
        redirect_url: redirect_url,
        webhook_url: webhook_url,
        metadata: { wz_user_id: user.id }
      )
      subject
    end

    it 'sets the checkout url' do
      subject
      expect(subscription.checkout_url).to eql(checkout_url)
    end

    it "sets the mollie's customer id" do
      subject
      expect(subscription.mollie_customer_id).to eql(mollie_customer_id)
    end

    it { is_expected.to have_state(:initialized) }
  end

  describe '.find_by_mollie_payment!' do
    subject { described_class.find_by_mollie_payment!(payment_id) } # rubocop:disable Rails/DynamicFindBy

    let(:user) { create(:user, :with_a_pending_subscription) }
    let(:subscription) { user.subscription }

    it "gets the payment at Mollie's" do
      expect(Mollie::Payment).to receive(:get).with(payment_id)
      subject
    end

    it 'returns the subscription that corresponds with the Mollie payment_id' do
      expect(subject).to eql(subscription)
    end

    it 'decorates the subscription with the Mollie payment' do
      expect(subject.mollie_payment).to eql(payment_stub)
    end

    describe 'edge cases' do
      describe 'Mollie::Payment not found' do
        before do
          allow(Mollie::Payment).to receive(:get).and_raise(
            Mollie::ResourceNotFoundError.new('')
          )
        end

        it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      describe 'no payment_id' do
        let(:payment_id) { nil }

        it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      describe 'user not found' do
        let(:wz_user_id) { 'unknown' }

        it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end
  end

  describe '#payment_canceled?' do
    subject { described_class.find_by_mollie_payment!(payment_id) } # rubocop:disable Rails/DynamicFindBy

    let(:user) { create(:user, :with_a_pending_subscription) }
    let(:subscription) { user.subscription }

    context 'when unpaid and closed' do
      let(:payment_stub) do
        double(
          'Mollie::Payment',
          metadata: OpenStruct.new(wz_user_id: wz_user_id),
          open?: false,
          paid?: false
        )
      end

      it 'is canceled' do
        expect(subject.payment_canceled?).to be true
      end
    end

    context 'when paid' do
      let(:payment_stub) do
        double(
          'Mollie::Payment',
          metadata: OpenStruct.new(wz_user_id: wz_user_id),
          open?: false,
          paid?: true
        )
      end

      it 'is not canceled' do
        expect(subject.payment_canceled?).to be false
      end
    end

    context 'when open' do
      let(:payment_stub) do
        double(
          'Mollie::Payment',
          metadata: OpenStruct.new(wz_user_id: wz_user_id),
          open?: true,
          paid?: false
        )
      end

      it 'is not canceled' do
        expect(subject.payment_canceled?).to be false
      end
    end
  end

  describe '#activate' do
    before do
      allow(subscription).to receive(:mollie_payment).and_return(payment_stub)
      allow(UserMailer).to receive(:with).and_return(mailer_stub)
    end

    subject { subscription.activate }
    let(:user) { create(:user, :with_a_pending_subscription, trial: trial) }
    let(:trial) { build(:trial, expires_after: trial_days_left.days.from_now) }
    let(:trial_days_left) { 10 }
    let(:mollie_customer_id) { user.mollie_customer_id }
    let(:subscription) { user.subscription }
    let(:webhook_url) { 'http://test.host/webhooks/mollie/subscription' }
    let(:mailer_stub) do
      double('Mailer', activation_email: message_delivery_stub)
    end

    let(:message_delivery_stub) do
      double('MessageDelivery', deliver_later: nil)
    end

    describe 'valid mandate' do
      let(:mandate_valid?) { true }
      let(:mandate_pending?) { false }

      it "gets the mandate at Mollie's" do
        expect(Mollie::Customer::Mandate).to receive(:get).with(
          mandate_id,
          customer_id: mollie_customer_id
        )
        subject
      end

      it "creates a subscription at Mollie's" do
        expect(Mollie::Customer::Subscription).to receive(:create).with(
          customer_id: mollie_customer_id,
          amount: { value: '7.99', currency: 'EUR' },
          interval: '30 days',
          startDate: (30 + trial_days_left + 1).days.from_now.to_date,
          description: 'Wingzzz monthly payment'
        )
        subject
      end

      it 'sends a mail' do
        expect(UserMailer).to receive(:with).with(
          user: user,
          next_payment_on: (30 + trial_days_left + 1).days.from_now.to_date
        )
          .and_return(mailer_stub)
        expect(message_delivery_stub).to receive(:deliver_later)
        subject
      end

      it do
        subject
        expect(subscription).to have_state(:active)
      end
    end

    describe 'pending mandate' do
      let(:mandate_valid?) { false }
      let(:mandate_pending?) { true }
      let(:user) { create(:user, :with_a_pending_subscription, trial: trial) }
      let(:trial) do
        build(:trial, expires_after: trial_days_left.days.from_now)
      end
      let(:trial_days_left) { 10 }

      it "gets the mandate at Mollie's" do
        expect(Mollie::Customer::Mandate).to receive(:get).with(
          mandate_id,
          customer_id: mollie_customer_id
        )
        subject
      end

      it "creates a subscription at Mollie's" do
        expect(Mollie::Customer::Subscription).to receive(:create).with(
          customer_id: mollie_customer_id,
          amount: { value: '7.99', currency: 'EUR' },
          interval: '30 days',
          startDate: (30 + trial_days_left + 1).days.from_now.to_date,
          description: 'Wingzzz monthly payment'
        )
        subject
      end

      it do
        subject
        expect(subscription).to have_state(:active)
      end
    end

    describe 'no valid or pending mandate' do
      let(:mandate_valid?) { false }
      let(:mandate_pending?) { false }

      it "does not create a subscription at Mollie's" do
        expect(Mollie::Customer::Subscription).not_to receive(:create)
        expect { subject }.to raise_exception(AASM::InvalidTransition)
      end

      it 'does not activate the subscription' do
        expect(subscription).not_to transition_from(:pending).to(:active)
          .on_event(:activate)
      end
    end

    describe 'active subscription' do
      let(:user) { create(:user, :with_an_active_subscription) }

      it "does not get the mandate at Mollie's" do
        expect(Mollie::Customer::Mandate).not_to receive(:get)
        expect { subject }.to raise_exception(AASM::InvalidTransition)
      end

      it "does not create a subscription at Mollie's" do
        expect(Mollie::Customer::Subscription).not_to receive(:create)
        expect { subject }.to raise_exception(AASM::InvalidTransition)
      end

      it 'does not activate the subscription' do
        expect(subscription).not_to transition_from(:active).to(:active)
          .on_event(:activate)
      end
    end
  end

  describe '#mollie_customer_id' do
    let(:instance) { user.subscription }
    let(:user) { create(:user, :with_an_active_subscription) }
    let(:mollie_customer_id) { user.mollie_customer_id }
    let(:new_mollie_customer_id) { 'new_mollie_customer_id' }

    describe 'getter' do
      subject { instance.mollie_customer_id }
      it 'delegates to the user' do
        expect(subject).to eql(mollie_customer_id)
      end
    end

    describe 'setter' do
      subject { user.mollie_customer_id }

      it 'sets mollie_customer_id on the user' do
        instance.mollie_customer_id = new_mollie_customer_id
        expect(subject).to eql(new_mollie_customer_id)
      end
    end
  end

  describe '#mollie_subscription' do
    before { instance.update(mollie_subscription_id: mollie_subscription_id) }

    subject { instance.mollie_subscription }
    let(:instance) { user.subscription }
    let(:user) { create(:user, :with_an_active_subscription) }
    let(:mollie_customer_id) { user.mollie_customer_id }
    let(:mollie_subscription_id) { 'mollie_subscription_id' }

    it do
      expect(Mollie::Customer::Subscription).to receive(:get).with(
        mollie_subscription_id,
        customer_id: mollie_customer_id
      )
      subject
    end
  end

  describe '#grace_period_ended?' do
    subject { instance.grace_period_ended? }

    let(:instance) do
      build(:subscription, grace_period_ends_on: grace_period_ends_on)
    end

    describe 'w/o grace period' do
      let(:grace_period_ends_on) { nil }

      it { is_expected.to be_falsy }
    end

    describe 'w/ grace period in the past' do
      let(:grace_period_ends_on) { 2.days.ago }

      it { is_expected.to be_truthy }
    end

    describe 'w/ grace period today' do
      let(:grace_period_ends_on) { Date.current }

      it { is_expected.to be_falsy }
    end

    describe 'w/ grace period in the future' do
      let(:grace_period_ends_on) { 2.days.from_now }

      it { is_expected.to be_falsy }
    end
  end

  describe '#in_grace_period?' do
    subject { instance.in_grace_period? }

    let(:instance) do
      build(:subscription, grace_period_ends_on: grace_period_ends_on)
    end

    describe 'w/o grace period' do
      let(:grace_period_ends_on) { nil }

      it { is_expected.to be_truthy }
    end

    describe 'w/ grace period in the past' do
      let(:grace_period_ends_on) { 2.days.ago }

      it { is_expected.to be_falsy }
    end

    describe 'w/ grace period today' do
      let(:grace_period_ends_on) { Date.current }

      it { is_expected.to be_truthy }
    end

    describe 'w/ grace period in the future' do
      let(:grace_period_ends_on) { 2.days.from_now }

      it { is_expected.to be_truthy }
    end
  end
end
