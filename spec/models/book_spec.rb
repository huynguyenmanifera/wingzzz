require 'rails_helper'
require 'book_storage/local'
require 'book_storage/s3'

RSpec.describe Book, type: :model do
  describe 'validations' do
    let(:instance) { create(:book, title: 'Lorem') }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_length_of(:summary).is_at_most(1_024) }
    it do
      is_expected.to validate_numericality_of(:trending_now_position)
        .is_greater_than(0)
        .is_less_than(128)
    end

    context 'slug' do
      context 'invalid slug set' do
        let(:book) { build :book, slug: ' ' }

        it do
          expect(book).to be_invalid
          expect(book.errors[:slug]).not_to be_empty
        end
      end

      context 'no slug set' do
        let(:book) { build :book }

        it do
          expect(book).to be_valid
          expect(book.errors[:slug]).to be_empty
        end
      end
    end

    context 'language' do
      context 'no language set' do
        let(:book) { build :book, language: nil }

        it do
          expect(book).to be_valid
          expect(book.language).to eql('en')
        end
      end

      context 'supported language set' do
        let(:book) { build :book, language: 'nl' }

        it do
          expect(book).to be_valid
          expect(book.language).to eql('nl')
        end
      end

      context 'non-supported language set' do
        let(:book) { build :book, language: 'qq-QQ' }

        it do
          expect(book).to be_invalid
          expect(book.errors[:language]).not_to be_empty
        end
      end
    end

    context 'layout' do
      context 'no layout set' do
        let(:book) { build :book, layout: nil }

        it do
          expect(book).to be_valid
          expect(book.layout).to eql('two_pages')
        end
      end

      context 'supported layout set' do
        let(:book) { build :book, layout: 'single_page' }

        it do
          expect(book).to be_valid
          expect(book.layout).to eql('single_page')
        end
      end

      context 'non-supported layout set' do
        let(:book) { build :book, layout: 'non_existing_layout' }

        it do
          expect(book).to be_invalid
          expect(book.errors[:layout]).not_to be_empty
        end
      end

      context 'reader is set to default' do
        let(:book) { build :book, reader: 0 }

        it do
          expect(book).to be_valid
          expect(book.reader).to eql('default')
        end
      end

      context 'animated reader set' do
        let(:book) { build :book, reader: 1 }

        it do
          expect(book).to be_valid
          expect(book.reader).to eql('animated')
        end
      end
    end
  end

  describe 'scopes' do
    describe '.recently_added' do
      let!(:book1) { create(:book, created_at: 1.day.ago) }
      let!(:book2) { create(:book, created_at: 2.days.ago) }
      let!(:book3) { create(:book, created_at: 3.days.ago) }
      let!(:book4) { create(:book, created_at: 4.days.ago) }

      describe 'with count specified' do
        subject { described_class.recently_added(3) }

        it { is_expected.to eq([book1, book2, book3]) }
      end

      describe 'with no count specified' do
        subject { described_class.recently_added }

        it { is_expected.to eq([book1, book2, book3, book4]) }
      end
    end

    describe '.currently_reading' do
      let(:profile) { create :profile }
      let!(:book1) { create(:book) }
      let!(:book2) { create(:book) }
      let!(:book3) { create(:book) }
      let!(:book4) { create(:book) }
      let!(:book5) { create(:book) }

      before do
        create :book_session,
               book: book1, profile: profile, created_at: 4.days.ago
        create :book_session,
               book: book2, profile: profile, created_at: 2.days.ago
        create :book_session,
               book: book3, profile: profile, created_at: 1.day.ago
      end

      describe 'with count specified' do
        subject { described_class.currently_reading(profile, 2) }

        it { is_expected.to eq([book3, book2]) }
      end

      describe 'with no count specified' do
        subject { described_class.currently_reading(profile) }

        it { is_expected.to eq([book3, book2, book1]) }
      end
    end

    describe '.trending_now' do
      let!(:book1) { create(:book, trending_now_position: 2) }
      let!(:book2) { create(:book, trending_now_position: 1) }
      let!(:book3) { create(:book, trending_now_position: nil) }
      let!(:book4) { create(:book, trending_now_position: 3) }
      let!(:book5) { create(:book, trending_now_position: 4) }

      describe 'with count specified' do
        subject { described_class.trending_now(3) }

        it { is_expected.to eq([book2, book1, book4]) }
      end

      describe 'with no count specified' do
        subject { described_class.trending_now }

        it { is_expected.to eq([book2, book1, book4, book5]) }
      end
    end
  end

  describe '#slug' do
    subject { instance.slug }

    let(:title) { 'Lorem Ipsum' }
    let(:instance) { create(:book, title: title) }

    it { is_expected.to eql('lorem-ipsum') }

    context 'duplicate title' do
      before do
        create(:book, title: title)
        allow(SecureRandom).to receive(:hex).with(2).and_return('dolo')
      end

      it { is_expected.to eql('lorem-ipsum-dolo') }
    end

    context 'long title' do
      let(:title) { 'Q' * 255 }
      let(:expected_slug) { 'q' * 250 + '-dolo' }

      before do
        create(:book, title: title)
        allow(SecureRandom).to receive(:hex).with(2).and_return('dolo')
      end

      it { is_expected.to eql(expected_slug) }
    end

    context 'slug already set' do
      let(:expected_slug) { 'consectetur' }
      let(:instance) { create(:book, title: title, slug: expected_slug) }

      it { is_expected.to eql(expected_slug) }
    end
  end

  describe 'storage' do
    before { allow(Wingzzz).to receive(:config).and_return(config) }

    let(:config) { OpenStruct.new(books: { storage: storage }) }
    let(:book) { build :book }

    context 'with Local' do
      let(:storage) { 'Local' }

      it { expect(book.storage).to be_an_instance_of(BookStorage::Local) }

      it do
        expect(BookStorage::Local).to receive(:new).with(book)
        book.storage
      end
    end

    context 'with S3' do
      let(:storage) { 'S3' }

      it { expect(book.storage).to be_an_instance_of(BookStorage::S3) }

      it do
        expect(BookStorage::S3).to receive(:new).with(book)
        book.storage
      end
    end
  end
end
