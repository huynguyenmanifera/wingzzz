require 'rails_helper'

RSpec.describe LinkToTolkComponent, type: :component do
  subject { Capybara.string(html) }

  let(:html) { render_inline(instance) }
  let(:instance) { described_class.new(options) }
  let(:options) { { tolk_url: tolk_url, engine: engine } }
  let(:engine) { double('Tolk', root_path: 'tolk/') }

  describe 'without tolk_url' do
    let(:tolk_url) { '' }
    it { is_expected.to have_css('a[href="tolk/"][target="_blank"]') }
  end

  describe 'with tolk_url' do
    let(:tolk_url) { 'https://example.org' }
    it do
      is_expected.to have_css(
        'a[href="https://example.org/tolk/"][target="_blank"]'
      )
    end
  end
end
