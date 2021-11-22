require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#external_link_to' do
    subject { helper.external_link_to :contact }

    it do
      is_expected.to have_css(
        'a[href="https://mywingzzz.com/HOME_NL/contact.html?_ga=2.258866698.1092233683.1601290738-131483274.1595657181"][rel="noopener noreferrer"][target="_blank"]',
        text: 'Contact'
      )
    end
  end

  describe '#link_to_pdf_to_epub_converter' do
    subject { helper.link_to_pdf_to_epub_converter }

    it do
      is_expected.to have_css(
        'a.link[href="https://wz-book-converter.herokuapp.com/"][rel="noopener noreferrer"][target="_blank"]'
      )
    end
  end
end
