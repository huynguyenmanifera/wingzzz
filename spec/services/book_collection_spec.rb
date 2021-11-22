require 'rails_helper'

RSpec.describe BookCollection do
  describe '.from_filters' do
    let(:profile) { create(:profile, content_language: 'en') }
    subject { described_class.from_filters(filters, profile) }

    let(:filters) { {} }

    it { is_expected.to be_a(described_class) }
  end

  describe '#filters' do
    let(:profile) { create(:profile, content_language: 'en') }
    subject { instance.filters }

    let(:instance) { described_class.new(filters, profile) }
    let(:filters) { { foo: 'bar' } }

    it { is_expected.to eql(filters) }

    context 'with Action Controller Parameters' do
      let(:filters) { ActionController::Parameters.new(foo: 'bar') }

      it { is_expected.to be_a(Hash) }
    end

    context 'with nil as filters passed' do
      let(:filters) { nil }

      it { is_expected.to be_a(Hash) }
    end
  end

  describe '#results_current_language' do
    subject { instance.results_current_language }

    let(:profile) { create(:profile, content_language: 'en') }
    let(:instance) { described_class.new(filters, profile) }
    let(:filters) { {} }

    describe 'sorting' do
      let!(:robinson) { create :book, title: 'Robinson Crusoe', language: 'en' }
      let!(:alice) do
        create :book, title: "Alice's Adventures in Wonderland", language: 'en'
      end
      let!(:oliver) { create :book, title: 'Oliver Twist', language: 'en' }

      it 'sorts alphabetically' do
        is_expected.to eq([alice, oliver, robinson])
      end
    end

    context 'when passing query' do
      let!(:robinson) { create :book, title: 'Robinson Crusoe', language: 'en' }
      let!(:alice) do
        create :book, title: "Alice's Adventures in Wonderland", language: 'en'
      end
      let!(:oliver) { create :book, title: 'Oliver Twist', language: 'en' }

      let(:filters) { { q: 'adventure' } }

      it { is_expected.to contain_exactly(alice) }
    end

    context 'when passing query and there is a keyword match' do
      let!(:robinson) do
        create :book,
               title: 'Robinson Crusoe',
               language: 'en',
               keyword_list: %w[island]
      end
      let!(:alice) do
        create :book,
               title: "Alice's Adventures in Wonderland",
               language: 'en',
               keyword_list: %w[magic]
      end
      let!(:oliver) do
        create :book,
               title: 'Oliver Twist', language: 'en', keyword_list: %w[orphan]
      end

      let(:filters) { { q: 'island' } }

      it { is_expected.to contain_exactly(robinson) }
    end

    context 'when passing query and there is a keyword match with multiple results' do
      let!(:robinson) do
        create :book,
               title: 'Robinson Crusoe',
               language: 'en',
               keyword_list: %w[island]
      end
      let!(:alice) do
        create :book,
               title: "Alice's Adventures in Wonderland",
               language: 'en',
               keyword_list: %w[magic mother]
      end
      let!(:oliver) do
        create :book,
               title: 'Oliver Twist',
               language: 'en',
               keyword_list: %w[orphan mother]
      end

      let(:filters) { { q: 'mother' } }

      it { is_expected.to include(oliver, alice) }
    end

    describe 'age filter' do
      let!(:book_1_to_2) do
        create :book, min_age_in_months: 1, max_age_in_months: 2, language: 'en'
      end
      let!(:book_1_to_5) do
        create :book, min_age_in_months: 1, max_age_in_months: 5, language: 'en'
      end
      let!(:book_1_to_7) do
        create :book, min_age_in_months: 1, max_age_in_months: 7, language: 'en'
      end
      let!(:book_1_to_100) do
        create :book,
               min_age_in_months: 1, max_age_in_months: 100, language: 'en'
      end

      let!(:book_6_to_9) do
        create :book, min_age_in_months: 6, max_age_in_months: 9, language: 'en'
      end
      let!(:book_6_to_10) do
        create :book,
               min_age_in_months: 6, max_age_in_months: 10, language: 'en'
      end
      let!(:book_6_to_14) do
        create :book,
               min_age_in_months: 6, max_age_in_months: 14, language: 'en'
      end

      let!(:book_10_to_17) do
        create :book,
               min_age_in_months: 10, max_age_in_months: 17, language: 'en'
      end

      let(:profile) do
        create :profile,
               min_age_in_months: 5,
               max_age_in_months: 10,
               content_language: 'en'
      end

      context 'when min and max are set' do
        context 'when min and max are equal' do
          let(:profile) do
            create :profile, min_age_in_months: 1, max_age_in_months: 1
          end

          it 'returns books with overlapping ranges using closed intervals' do
            is_expected.to contain_exactly(
              book_1_to_2,
              book_1_to_5,
              book_1_to_7,
              book_1_to_100
            )
          end
        end
      end

      context 'when min and max are set' do
        let(:profile) do
          create :profile,
                 min_age_in_months: 5,
                 max_age_in_months: 10,
                 content_language: 'en'
        end

        context 'when min and max are not equal' do
          let(:profile) do
            create :profile, min_age_in_months: 5, max_age_in_months: 10
          end

          it 'returns books with overlapping ranges using open intervals' do
            is_expected.to contain_exactly(
              book_1_to_7,
              book_1_to_100,
              book_6_to_9,
              book_6_to_10,
              book_6_to_14
            )
          end
        end
      end

      context 'when neither min nor max is set' do
        let(:profile) do
          create :profile,
                 min_age_in_months: nil,
                 max_age_in_months: nil,
                 content_language: 'en'
        end

        it 'returns all books' do
          is_expected.to contain_exactly(
            book_1_to_2,
            book_1_to_5,
            book_1_to_7,
            book_1_to_100,
            book_6_to_9,
            book_6_to_10,
            book_6_to_14,
            book_10_to_17
          )
        end
      end

      context 'when only min is set' do
        let(:profile) do
          create :profile,
                 min_age_in_months: 10,
                 max_age_in_months: nil,
                 content_language: 'en'
        end

        it 'returns book from min and up' do
          is_expected.to contain_exactly(
            book_1_to_100,
            book_6_to_14,
            book_10_to_17
          )
        end
      end

      context 'when only max is set' do
        let(:profile) do
          create :profile,
                 min_age_in_months: nil,
                 max_age_in_months: 6,
                 content_language: 'en'
        end

        it 'returns book from min and up' do
          is_expected.to contain_exactly(
            book_1_to_2,
            book_1_to_5,
            book_1_to_7,
            book_1_to_100
          )
        end
      end
    end

    describe 'content language filter' do
      let(:profile) do
        create :profile,
               min_age_in_months: nil,
               max_age_in_months: nil,
               content_language: 'en'
      end

      let!(:book_nl) { create :book, language: 'nl', title: 'Mijn Boek' }
      let!(:book_en) { create :book, language: 'en', title: 'My Book' }

      context 'when no query is passed' do
        it 'returns only books matching content language' do
          is_expected.to contain_exactly(book_en)
        end
      end

      context 'when empty query is passed' do
        let(:filters) { { q: '' } }

        it 'returns only books matching content language' do
          is_expected.to contain_exactly(book_en)
        end
      end
    end
  end

  describe '#results_other_languages' do
    subject { instance.results_other_languages }

    let(:profile) { create(:profile, content_language: 'en') }
    let(:instance) { described_class.new(filters, profile) }
    let(:filters) { {} }

    let!(:book_en) { create(:book, language: 'en') }
    let!(:book_nl) { create(:book, language: 'nl') }

    it 'only returns books in other languages' do
      is_expected.to contain_exactly(book_nl)
    end
  end

  describe 'filter for authors' do
    subject { instance.results_current_language }

    let(:profile) { create(:profile, content_language: 'en') }
    let(:instance) { described_class.new(filters, profile) }
    let(:filters) { {} }

    let!(:robinson) { create :book, title: 'Robinson Crusoe', language: 'en' }
    let!(:defoe) { create :author, name: 'Daniel Defoe' }
    let!(:oldman) { create :book, title: 'Old Man and the sea', language: 'en' }
    let!(:hemmingway) { create :author, name: 'Ernest Hemmingway' }
    let(:filters) { { q: 'Daniel Defoe' } }

    it 'expected to return only books with the searched author' do
      robinson.authors = [defoe]
      oldman.authors = [hemmingway]
      is_expected.to contain_exactly(robinson)
      is_expected.not_to include(oldman)
    end
  end
end
