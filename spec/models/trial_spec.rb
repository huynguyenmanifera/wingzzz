require 'rails_helper'

RSpec.describe Trial, type: :model do
  let(:today) { Date.current }

  describe '#active?' do
    it 'is active if expires_after is after today' do
      trial = Trial.new(expires_after: today + 1.day)
      expect(trial.active?(today)).to be true
    end

    it 'is active if expires_after is equal to today' do
      trial = Trial.new(expires_after: today)
      expect(trial.active?(today)).to be true
    end

    it 'is not active if today is after expires_after' do
      trial = Trial.new(expires_after: today - 1.day)
      expect(trial.active?(today)).to be false
    end
  end

  describe '#expired?' do
    it 'is expired if today is after expires_after' do
      trial = Trial.new(expires_after: today - 1.day)
      expect(trial.expired?(today)).to be true
    end

    it 'is not expired if expires_after is after today' do
      trial = Trial.new(expires_after: today + 1.day)
      expect(trial.expired?(today)).to be false
    end
  end

  describe '#days_left' do
    it 'is a positive number if today is before expires_after' do
      trial = Trial.new(expires_after: today + 3.days)
      expect(trial.days_left).to be 4
    end

    it 'is 1 if trial expires today' do
      trial = Trial.new(expires_after: today)
      expect(trial.days_left).to be 1
    end

    it 'is 0 if trial is expired' do
      trial = Trial.new(expires_after: today - 1.day)
      expect(trial.days_left).to be 0
    end
  end
end
