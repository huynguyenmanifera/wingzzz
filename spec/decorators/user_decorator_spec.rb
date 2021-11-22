require 'rails_helper'

RSpec.describe UserDecorator do
  let(:user) { build :user, trial: trial }
  let(:trial) { build :trial, expires_after: Date.new(1_955, 11, 5) }
  let(:decorator) { described_class.new(user) }

  describe '#localized_trail_period_expired_from' do
    subject { decorator.localized_trail_period_expired_from }

    it { is_expected.to eql('November 06, 1955') }
  end
end
