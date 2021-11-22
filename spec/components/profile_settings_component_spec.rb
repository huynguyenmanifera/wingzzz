require 'rails_helper'

RSpec.describe ProfileSettingsComponent, type: :component do
  let(:profile) { create :profile }

  subject do
    Capybara.string(render_inline(described_class.new(profile: profile)))
  end

  describe 'form inputs' do
    describe 'min_age_in_months' do
      let(:profile) { create :profile, min_age_in_months: 48 }

      it 'has correct value' do
        expect(subject).to have_select(
          'profile[min_age_in_months]',
          selected: '4 years'
        )
      end
    end

    describe 'max_age_in_months' do
      let(:profile) { create :profile, min_age_in_months: 120 }

      it 'has correct value' do
        expect(subject).to have_select(
          'profile[min_age_in_months]',
          selected: '10 years'
        )
      end
    end
  end
end
