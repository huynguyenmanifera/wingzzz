require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:profiles).dependent(:destroy) }
    it { is_expected.to have_one(:subscription).dependent(:destroy) }
    it { is_expected.to have_one(:trial).dependent(:destroy) }
  end

  describe 'scopes' do
    describe '.on_last_day_of_trial' do
      subject { described_class.on_last_day_of_trial }

      let(:user_on_last_day_of_trial) { create(:user, :on_last_day_of_trial) }
      let(:user_in_trial_period) { create(:user, :in_trial_period) }
      let(:user_with_expired_trial) { create(:user, :with_expired_trial) }
      let(:user_without_a_trial) { create(:user, trial: nil) }

      it { is_expected.to contain_exactly(user_on_last_day_of_trial) }
    end

    describe 'a .trial_ended_days_ago' do
      subject { described_class.trial_ended_days_ago(days_after_trial) }

      let(:days_after_trial) { 10 }
      let(:user_on_last_day_of_trial) { create(:user, :on_last_day_of_trial) }
      let(:user_in_trial_period) { create(:user, :in_trial_period) }
      let(:user_with_expired_trial) { create(:user, :with_expired_trial) }
      let(:user_without_a_trial) { create(:user, trial: nil) }
      let(:user_on_10_days_after_trial) do
        create(
          :user,
          trial: build(:trial, expires_after: days_after_trial.days.ago)
        )
      end

      it { is_expected.to contain_exactly(user_on_10_days_after_trial) }
    end

    describe '.without_subscription' do
      subject { described_class.without_subscription }

      let(:user_without_a_subscription) { create(:user) }
      let(:user_with_a_subscription) do
        create(:user, :with_an_active_subscription)
      end

      it { is_expected.to contain_exactly(user_without_a_subscription) }
    end

    describe '.non_admin' do
      subject { described_class.non_admin }

      let(:non_admin) { create(:user) }
      let(:admin) { create(:user, :admin) }

      it { is_expected.to contain_exactly(non_admin) }
    end
  end

  describe '#create' do
    subject { created_user }
    let(:created_user) { create :user }
    let(:default_profile) { created_user.profiles.first }

    it 'automatically creates a default profile' do
      expect(subject.profiles.size).to eq(1)
    end

    describe 'created default profile' do
      subject { default_profile }

      it { is_expected.to be_persisted }
    end
  end

  describe '#locale' do
    describe 'validations' do
      context 'not set' do
        let(:user) { create :user, locale: nil }
        it { expect(user).to be_valid }
        it { expect(user.locale).to eq('en') }
      end

      context 'recognized locale code' do
        let(:user) { build :user, locale: 'nl' }
        it { expect(user).to be_valid }
        it { expect(user.locale).to eq('nl') }
      end

      context 'unrecognized locale code' do
        let(:user) { build :user, locale: 'qq' }
        it { expect(user).to be_invalid }
      end
    end
  end

  describe '#mollie_customer' do
    subject { instance.mollie_customer }

    let(:instance) { create(:user, mollie_customer_id: mollie_customer_id) }

    describe 'with mollie_customer_id' do
      let(:mollie_customer_id) { 'mollie_customer_id' }

      it do
        expect(Mollie::Customer).to receive(:get).with(mollie_customer_id).once
        2.times { subject }
      end
    end

    describe 'without mollie_customer_id' do
      let(:mollie_customer_id) { nil }

      it do
        expect(Mollie::Customer).not_to receive(:get)
        subject
      end
    end
  end

  describe '#mollie_mandate' do
    subject { instance.mollie_mandate }

    let(:instance) { create(:user, mollie_customer_id: mollie_customer_id) }

    describe 'with mollie_customer' do
      before do
        allow(Mollie::Customer).to receive(:get).and_return(
          mollie_customer_stub
        )
      end

      let(:mollie_customer_stub) do
        double('customer', mandates: mollie_mandates_stub)
      end
      let(:mollie_mandates_stub) { [expected_mandate, double('mandate')] }
      let(:expected_mandate) { double('mandate') }
      let(:mollie_customer_id) { 'mollie_customer_id' }

      it 'get the first mandate from the Mollie customer' do
        is_expected.to eql(expected_mandate)
      end
    end

    describe 'without mollie_customer' do
      let(:mollie_customer_id) { nil }

      it { is_expected.to be_nil }
    end
  end

  describe '#subscribe' do
    before do
      allow(instance).to receive(:create_subscription).and_return(
        subscription_stub
      )
      allow_any_instance_of(Subscription).to receive(:resubscribe!)
    end

    subject { instance.subscribe }

    let(:subscription_stub) { Subscription.new }
    let(:body_stub) { double('body').as_null_object }

    describe 'user has no subscription' do
      let(:instance) { create(:user, subscription: nil) }

      it 'creates a subscription' do
        expect(instance).to receive(:create_subscription)
        subject
      end

      it 'returns the subscription' do
        expect(subject).to be_a(Subscription)
      end
    end

    describe 'user has a subscription' do
      let(:instance) { create(:user, :with_a_canceled_subscription) }

      it 'resubscribes' do
        expect(instance.subscription).to receive(:resubscribe!)
        subject
      end

      it 'returns the subscription' do
        expect(subject).to be_a(Subscription)
      end
    end
  end

  describe '#unsubscribe' do
    before { allow_any_instance_of(Subscription).to receive(:cancel!) }

    subject { instance.unsubscribe }
    let(:instance) { create(:user, :with_an_active_subscription) }

    it 'cancels the subscription' do
      expect(instance.subscription).to receive(:cancel!)
      subject
    end

    it 'returns the subscription' do
      expect(subject).to be_a(Subscription)
    end
  end

  describe 'from_omniauth' do
    subject { created_user }
    context 'non existing user' do
      let(:created_user) { nil }
      let(:auth) { nil }
      it 'creates a user with facebook provider from facebook auth hash' do
        auth = mock_auth_hash 'facebook'
        created_user = User.from_omniauth auth
        expect(created_user).to be_a(User)
        expect(created_user.provider).to eq('facebook')
        expect(created_user.uid).to eq('123545')
        expect(created_user.email).to eq('omniuser@example.org')
        expect(created_user.confirmation_token).to eq(nil)
        expect(created_user.confirmed_at).to be_a(ActiveSupport::TimeWithZone)
      end

      it 'creates a user with google_oauth2 provider from google_oauth2 auth hash' do
        auth = mock_auth_hash 'google_oauth2'
        created_user = User.from_omniauth auth
        expect(created_user).to be_a(User)
        expect(created_user.provider).to eq('google_oauth2')
        expect(created_user.uid).to eq('123545')
        expect(created_user.email).to eq('omniuser@example.org')
        expect(created_user.confirmation_token).to eq(nil)
        expect(created_user.confirmed_at).to be_a(ActiveSupport::TimeWithZone)
      end
    end

    context 'existing user' do
      let(:existing_user) { create(:user, email: 'omniuser@example.org') }
      let(:created_user) { nil }
      let(:auth) { nil }

      it 'retrieves existing user by email from facebook auth hash' do
        allow(User).to receive(:find_by_email).and_return(existing_user)
        auth = mock_auth_hash 'facebook'
        created_user = User.from_omniauth auth
        expect(created_user).to be_a(User)
        expect(created_user).to eq(existing_user)
      end
    end
  end
end
