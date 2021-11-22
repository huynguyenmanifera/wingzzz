require 'rails_helper'

RSpec.describe Books::ListItemComponent, type: :component do
  subject { Capybara.string(html) }
  let(:html) { render_inline(instance) }
  let(:instance) { described_class.new(options) }
  let(:options) do
    { book: book, show_preview: show_preview, item_type: item_type }
  end
  let(:book) { create(:book).decorate }

  describe "with item type 'concise'" do
    let(:item_type) { :concise }

    describe 'with preview' do
      let(:show_preview) { true }

      it do
        is_expected.to have_css(
          'li[data-controller="book"][data-action="click->book#open"]'
        )
      end

      it do
        is_expected.to have_css(
          'li.book-list-item.py-3.mr-8 > .book-list-item__thumbnail.cursor-pointer.shadow-lg > .transition.duration-300.transform'
        )
      end

      it { is_expected.to have_css('li template', visible: false) }
      it { is_expected.to have_css('li a[href^="/books"] img') }
    end

    describe 'without preview' do
      let(:show_preview) { false }

      it do
        is_expected.not_to have_css(
          'li[data-controller="book"][data-action="click->book#open"]'
        )
      end
      it do
        is_expected.to have_css(
          'li.book-list-item.py-3.mr-8 > .book-list-item__thumbnail.cursor-pointer.shadow-lg > .transition.duration-300.transform'
        )
      end
      it { is_expected.not_to have_css('li template', visible: false) }
      it { is_expected.to have_css('li a[href^="/books"] img') }
    end
  end

  describe "with item type 'card'" do
    let(:item_type) { :card }

    describe 'with preview' do
      let(:show_preview) { true }

      it do
        is_expected.to have_css(
          'li[data-controller="book"][data-action="click->book#open"]'
        )
      end
      it do
        is_expected.to have_css(
          'li.book-list-item.mr-4 > .book-list-item__card.cursor-pointer.flex.p-5.rounded-sm.shadow-xl',
          text: book.title
        )
      end
      it { is_expected.to have_css('li template', visible: false) }
      it { is_expected.to have_css('li a[href^="/books"] img') }
    end

    describe 'without preview' do
      let(:show_preview) { false }

      it do
        is_expected.not_to have_css(
          'li[data-controller="book"][data-action="click->book#open"]'
        )
      end

      it do
        is_expected.to have_css(
          'li.book-list-item.mr-4 > .book-list-item__card.cursor-pointer.flex.p-5.rounded-sm.shadow-xl',
          text: book.title
        )
      end
      it { is_expected.not_to have_css('li template', visible: false) }
      it { is_expected.to have_css('li a[href^="/books"] img') }
    end
  end
end
