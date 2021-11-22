require 'rails_helper'

RSpec.describe AnalyticsEvents::BookProgressChange, type: :model do
  describe '#book_id' do
    it { should validate_presence_of(:book_id) }
    it { should validate_numericality_of(:book_id).only_integer }

    it { should_not allow_value(-1).for(:book_id) }
    it { should allow_value(123).for(:book_id) }
  end

  describe '#book_opened_at' do
    it { should validate_presence_of(:book_opened_at) }
    it { should validate_numericality_of(:book_opened_at).only_integer }

    it { should_not allow_value(-1).for(:book_opened_at) }
    it { should allow_value(34_543_534).for(:book_opened_at) }
  end

  describe '#previous_progress' do
    it { should validate_presence_of(:previous_progress) }
    it { should validate_numericality_of(:previous_progress) }

    it { should_not allow_value(-1).for(:previous_progress) }
    it { should allow_value(0).for(:previous_progress) }
    it { should allow_value(0.34).for(:previous_progress) }
    it { should allow_value(1).for(:previous_progress) }
    it { should_not allow_value(1.2).for(:previous_progress) }
  end

  describe '#new_progress' do
    it { should validate_presence_of(:new_progress) }
    it { should validate_numericality_of(:new_progress) }

    it { should_not allow_value(-1).for(:new_progress) }
    it { should allow_value(0).for(:new_progress) }
    it { should allow_value(0.34).for(:new_progress) }
    it { should allow_value(1).for(:new_progress) }
    it { should_not allow_value(1.2).for(:new_progress) }
  end
end
