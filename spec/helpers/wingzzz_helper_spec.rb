require 'rails_helper'

RSpec.describe WingzzzHelper, type: :helper do
  describe '#localized_subscription_amount' do
    subject { helper.localized_subscription_amount }

    it { is_expected.to eql('EUR7.99') }
  end
end
