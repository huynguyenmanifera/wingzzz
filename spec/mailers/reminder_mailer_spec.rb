require 'rails_helper'

RSpec.describe ReminderMailer, type: :mailer do
  describe '#last_day_of_trial' do
    subject { described_class.with(user: user).last_day_of_trial }

    describe 'EN user' do
      let(:user) { build(:user, locale: 'en') }

      it "renders the subject with user's locale" do
        expect(subject.subject).to eq(
          'Your 14-day free trial will end tomorrow'
        )
      end
    end
  end

  describe '#trial_ended' do
    subject { described_class.with(user: user).trial_ended }

    describe 'EN user' do
      let(:user) { build(:user, locale: 'en') }

      it "renders the subject with user's locale" do
        expect(subject.subject).to eq('Your 14-day free trial has ended')
      end
    end
  end

  describe '#last_day_of_trial_for_teachers' do
    subject { described_class.with(user: user).last_day_of_trial_for_teachers }

    describe 'EN user' do
      let(:user) { build(:user, locale: 'en') }

      it "renders the subject with user's locale" do
        expect(subject.subject).to eq(
          'Your 14-day free trial will end tomorrow'
        )
      end
    end
  end

  describe '#trial_ended_for_teachers' do
    subject { described_class.with(user: user).trial_ended_for_teachers }

    describe 'EN user' do
      let(:user) { build(:user, locale: 'en') }

      it "renders the subject with user's locale" do
        expect(subject.subject).to eq('Your 14-day free trial has ended')
      end
    end
  end
end
