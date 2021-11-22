require 'rails_helper'

RSpec.describe BookSession, type: :model do
  let(:book) { create :book }
  let(:profile) { create :profile }

  describe '#for' do
    context 'when no book session for profile exists' do
      it 'creates a new book session' do
        expect(BookSession.for(book, profile)).to be_truthy
      end

      describe 'created book session' do
        subject { BookSession.for(book, profile) }

        it { expect(subject.persisted?).to be(true) }
        it { expect(subject.current_page).to eq(1) }
        it { expect(subject.book).to eq(book) }
        it { expect(subject.profile).to eq(profile) }
      end
    end

    context 'when book session for profile already exists' do
      let!(:book_session) { create :book_session, book: book, profile: profile }

      it 'does not create a new book session' do
        expect { BookSession.for(book, profile) }.to_not(
          change { BookSession.count }
        )
      end

      it 'returns existing book session' do
        expect(BookSession.for(book, profile)).to eq(book_session)
      end
    end
  end
end
