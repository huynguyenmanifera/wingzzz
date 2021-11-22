require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'validation' do
    subject do
      build(
        :profile,
        min_age_in_months: min_age_in_months,
        max_age_in_months: max_age_in_months
      )
    end
    let(:min_age_in_months) { nil }
    let(:max_age_in_months) { nil }

    it { is_expected.to be_valid }

    context 'max_age_in_months' do
      context 'not numeric' do
        let(:max_age_in_months) { 'imnotanumber' }
        it { is_expected.to be_invalid }
      end

      context 'not integer' do
        let(:max_age_in_months) { 12.23 }
        it { is_expected.to be_invalid }
      end

      context 'negative integer' do
        let(:max_age_in_months) { -1 }
        it { is_expected.to be_invalid }
      end

      context 'min_age_in_months is present' do
        context 'greater or equal to min_age_in_months' do
          let(:min_age_in_months) { 12 }
          let(:max_age_in_months) { 120 }

          it { is_expected.to be_valid }
        end

        context 'lesser than min_age_in_months' do
          let(:min_age_in_months) { 120 }
          let(:max_age_in_months) { 12 }

          it { is_expected.to be_invalid }
        end

        context 'equal to min_age_in_months' do
          let(:min_age_in_months) { 42 }
          let(:max_age_in_months) { 42 }

          it { is_expected.to be_valid }
        end
      end
    end

    context 'min_age_in_months' do
      context 'not numeric' do
        let(:min_age_in_months) { 'imnotanumber' }
        it { is_expected.to be_invalid }
      end

      context 'not integer' do
        let(:min_age_in_months) { 12.23 }
        it { is_expected.to be_invalid }
      end

      context 'negative integer' do
        let(:min_age_in_months) { -1 }
        it { is_expected.to be_invalid }
      end
    end
  end

  describe '#content_language' do
    describe 'default value' do
      let(:current_locale) { :nl }
      let(:profile) { build :profile, content_language: nil }

      before { allow(I18n).to receive(:locale).and_return(current_locale) }

      it 'is equal to current locale' do
        profile.validate
        expect(profile.content_language).to eq(current_locale.to_s)
      end
    end

    describe 'validations' do
      context 'not set' do
        let(:profile) { build :profile, content_language: nil }
        it { expect(profile).to be_valid }
      end

      context 'recognized language code' do
        let(:profile) { build :profile, content_language: 'nl' }
        it { expect(profile).to be_valid }
      end

      context 'unrecognized language code' do
        let(:profile) { build :profile, content_language: 'qq-QQ' }

        it do
          expect(profile).to be_invalid
          expect(profile.errors[:content_language]).not_to be_empty
        end
      end
    end
  end
end
