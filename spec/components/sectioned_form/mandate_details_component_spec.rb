require 'rails_helper'

RSpec.describe SectionedForm::MandateDetailsComponent, type: :component do
  subject { Capybara.string(html) }

  let(:html) { render_inline(instance) }
  let(:instance) { described_class.new(options) }
  let(:options) { { mandate: mandate } }
  let(:mandate) { double('mandate', method: method, details: details) }
  let(:card_number) { '6787' }
  let(:card_expiry_date) { '2020-12-31' }
  let(:expected_expiry_date) { 'December 31, 2020' }
  let(:consumer_name) { 'John Doe' }
  let(:card_holder) { 'Jane Doe' }
  let(:consumer_account) { 'NL55INGB0000000000' }
  let(:expected_consumer_account) { 'NL55 INGB 0000 0000 00' }

  describe 'directcredit' do
    let(:method) { 'directdebit' }
    let(:details) do
      double(
        'details',
        consumer_name: consumer_name, consumer_account: consumer_account
      )
    end
    it { is_expected.to have_content('Payment method') }
    it { is_expected.to have_content('iDeal') }
    it { is_expected.to have_css('svg', count: 1) }

    it { is_expected.to have_content('Consumer name') }
    it { is_expected.to have_content(consumer_name) }

    it { is_expected.to have_content('Card number') }
    it { is_expected.to have_content(expected_consumer_account) }
  end

  describe 'credticard' do
    let(:method) { 'creditcard' }
    let(:details) do
      double(
        'details',
        card_number: card_number,
        card_expiry_date: card_expiry_date,
        card_holder: card_holder
      )
    end

    it { is_expected.to have_content('Payment method') }
    it { is_expected.to have_content('Credit or debit card') }
    it { is_expected.to have_css('svg', count: 3) }

    it { is_expected.to have_content('Card number') }
    it { is_expected.to have_content("**** **** **** #{card_number}") }

    it { is_expected.to have_content('Card holder') }
    it { is_expected.to have_content(card_holder) }

    it { is_expected.to have_content('Expiry date') }
    it { is_expected.to have_content(expected_expiry_date) }
  end

  describe 'paypal' do
    let(:method) { 'paypal' }
    let(:details) do
      double(
        'details',
        consumer_name: consumer_name, consumer_account: consumer_account
      )
    end
    it { is_expected.to have_content('Payment method') }
    it { is_expected.to have_content('PayPal') }
    it { is_expected.to have_css('svg', count: 1) }

    it { is_expected.to have_content('Consumer name') }
    it { is_expected.to have_content(consumer_name) }

    it { is_expected.to have_content('Card number') }
    it { is_expected.to have_content(expected_consumer_account) }
  end
end
