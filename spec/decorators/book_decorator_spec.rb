require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe BookDecorator do
  include CarrierWave::Test::Matchers
  let(:book) { build :book }
  let(:decorator) { described_class.new(book) }

  describe '#epub_url' do
    subject { decorator.epub_url }

    it 'is delegated to storage.epub_url' do
      expect(book.storage).to receive(:epub_url)
      subject
    end
  end

  describe '#formatted_age_range' do
    subject { decorator.formatted_age_range }
    let(:book) do
      create(
        :book,
        min_age_in_months: min_age_in_months,
        max_age_in_months: max_age_in_months
      )
    end

    describe 'min_age_in_months and max_age_in_months set' do
      describe 'both under 2 years' do
        let(:min_age_in_months) { 6 }
        let(:max_age_in_months) { 18 }

        it { is_expected.to eql('6 - 18 months') }
      end

      describe 'both above 2 years' do
        let(:min_age_in_months) { 36 }
        let(:max_age_in_months) { 72 }

        it { is_expected.to eql('3 - 6 years') }
      end

      describe 'max age above 2 years' do
        let(:min_age_in_months) { 18 }
        let(:max_age_in_months) { 72 }

        it { is_expected.to eql('18 months - 6 years') }
      end
    end

    describe 'min_age_in_months not set, max_age_in_months under 2 years' do
      let(:min_age_in_months) { nil }
      let(:max_age_in_months) { 18 }

      it { is_expected.to eql('0 - 18 months') }
    end

    describe 'min_age_in_months not set, max_age_in_months above 2 years' do
      let(:min_age_in_months) { nil }
      let(:max_age_in_months) { 72 }

      it { is_expected.to eql('0 - 6 years') }
    end

    describe 'min_age_in_months set to zero' do
      let(:min_age_in_months) { 0 }
      let(:max_age_in_months) { 72 }

      it { is_expected.to eql('0 - 6 years') }
    end

    describe 'max_age_in_months not set' do
      let(:min_age_in_months) { 36 }
      let(:max_age_in_months) { nil }

      it { is_expected.to eql('3 - 12+ years') }
    end

    describe 'min_age_in_months nor max_age_in_months set' do
      let(:min_age_in_months) { nil }
      let(:max_age_in_months) { nil }

      it { is_expected.to eql('All ages') }
    end

    describe 'with one month' do
      let(:min_age_in_months) { 1 }
      let(:max_age_in_months) { nil }

      it { is_expected.to eql('1 month - 12+ years') }
    end
  end
end
