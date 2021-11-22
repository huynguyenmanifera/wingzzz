require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET #index' do
    let(:profile) { user.profiles.first }
    let(:book_collection) { double('books') }

    before do
      allow(BookCollection).to receive(:from_filters).and_return(
        book_collection
      )
      basic_auth(*Wingzzz.config.admin.values)
    end

    def do_get
      get :index
    end

    describe 'not signed in' do
      it 'redirects to the signin page' do
        expect(do_get).to redirect_to(new_user_session_path(locale: nil))
      end
    end

    describe 'signed in' do
      before { sign_in user }

      describe 'without a subscription' do
        context 'admin' do
          let(:user) { create(:user, admin: true) }

          it 'assigns a collection of books to the view' do
            do_get
            expect(assigns[:book_collection]).to eql(book_collection)
          end
        end

        context 'non-admin' do
          let(:user) { create(:user) }

          it 'needs to setup the subscription first' do
            expect(do_get).to redirect_to(new_subscription_path)
          end
        end
      end

      describe 'with a pending subscription' do
        describe 'and a expired trial' do
          let(:user) do
            create(:user, :with_a_pending_subscription, :with_expired_trial)
          end

          it "redirects to the subscription's show page" do
            expect(do_get).to redirect_to(subscription_path)
          end
        end

        describe 'and an active trial' do
          let(:user) do
            create(:user, :with_a_pending_subscription, :in_trial_period)
          end

          it 'does not redirect' do
            expect(do_get).to have_http_status(:ok)
          end
        end
      end

      describe 'with an active subscription' do
        let(:user) { create(:user, :with_an_active_subscription) }

        it 'let BookCollection handles the filtering' do
          expect(BookCollection).to receive(:from_filters).with(
            anything,
            profile
          )
          do_get
        end

        it 'assigns a collection of books to the view' do
          do_get
          expect(assigns[:book_collection]).to eql(book_collection)
        end
      end
    end
  end

  describe 'GET #show' do
    pending
  end
end
