require 'rails_helper'

RSpec.describe Page::FooterComponent, type: :component do
  subject { Capybara.string(html) }

  let(:html) { render_inline(instance) }
  let(:instance) { described_class.new(options) }
  let(:options) { { dark_mode: dark_mode } }
  let(:dark_mode) { true }

  it do
    is_expected.to have_css(
      'ul li:first',
      text: /Wingzzz B.V. All rights reserved/
    )
  end

  it do
    is_expected.to link_to_external_site(
      'https://www.mywingzzz.com/privacy.html',
      'Privacy policy'
    )
  end

  it do
    is_expected.to link_to_external_site(
      'https://mywingzzz.com/HOME_NL/contact.html?_ga=2.258866698.1092233683.1601290738-131483274.1595657181',
      'Contact'
    )
  end

  it do
    is_expected.to link_to_external_site(
      'https://www.mywingzzz.com/terms-and-conditions.html',
      'Terms and conditions'
    )
  end

  describe 'dark mode on' do
    it { is_expected.to have_css('ul li.text-wz-white-trn-500', count: 1) }
    it { is_expected.to have_css('ul li a.link.link-transparent', count: 3) }
  end

  describe 'dark mode off' do
    let(:dark_mode) { false }

    it { is_expected.to have_css('ul li.text-wz-gray-600', count: 1) }
    it { is_expected.to have_css('ul li a.link.opacity-75', count: 3) }
  end

  RSpec::Matchers.define :link_to_external_site do |url, text|
    match do |actual|
      expect(actual).to have_css("ul li a.link[href='#{url}']", text: text)
    end
  end
end
