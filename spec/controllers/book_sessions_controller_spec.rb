require 'rails_helper'
require 'application_helper'
require 'ahoy_matey'

RSpec.describe BookSessionsController, type: :controller do
  describe '#update' do
    let(:book) { create :book }
    let(:user) { create :user, :with_an_active_subscription, locale: 'en' }
    let(:current_profile) { user.profiles.first }

    before do
      allow_any_instance_of(ApplicationHelper).to receive(:current_profile)
        .and_return(current_profile)
      sign_in user
    end

    context 'book session' do
      def do_post
        post :update,
             params: { book_id: book.id, book_session: { current_page: 3 } }
      end

      it { expect { do_post }.to change { BookSession.count }.by(1) }

      describe 'created BookSession' do
        subject do
          do_post
          BookSession.last
        end

        it { expect(subject.profile).to eq(current_profile) }
        it { expect(subject.book).to eq(book) }
        it { expect(subject.current_page).to eq(3) }
      end
    end
  end
end
