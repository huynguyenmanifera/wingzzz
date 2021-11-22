require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#welcome_email' do
    subject { described_class.with(user: user).welcome_email }

    describe 'EN user' do
      let(:user) { build(:user, :in_trial_period, locale: 'en') }

      it 'renders the subject with users locale' do
        expect(subject.subject).to eq('Welcome to Wingzzz')
      end

      it 'renders the body with users locale' do
        expect(subject.body.encoded).to match(/Welcome to Wingzzz/)
      end
    end

    describe 'NL user' do
      let(:user) { build(:user, :in_trial_period, locale: 'nl') }

      it 'renders the subject with users locale' do
        expect(subject.subject).to eq('Welkom bij Wingzzz')
      end

      it 'renders the body with users locale' do
        expect(subject.body.encoded).to match(/Welkom bij Wingzzz/)
      end
    end
  end
end
