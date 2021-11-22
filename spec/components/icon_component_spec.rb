require 'rails_helper'

RSpec.describe IconComponent, type: :component do
  subject { Capybara.string(html) }
  let(:html) { render_inline(instance) }
  let(:instance) { described_class.new(options) }
  let(:options) { { icon: icon, size: size } }
  let(:icon) { 'lorem' }
  let(:size) { 'large' }
  let(:svg_stub) { '<svg/>'.html_safe }

  before do
    allow(instance).to receive(:inline_svg_tag).with(
      'icons/lorem.svg',
      any_args
    )
      .and_return(svg_stub)
  end

  it { is_expected.to have_css('.icon.icon-large svg') }

  it do
    expect(instance).to receive(:inline_svg_tag).with(
      'icons/lorem.svg',
      hash_including(:class)
    )
      .and_return(svg_stub)
    subject
  end

  describe 'sizes' do
    describe 'medium' do
      let(:size) { 'medium' }

      it { is_expected.to have_css('.icon.icon-medium svg') }
    end

    describe 'small' do
      let(:size) { 'small' }

      it { is_expected.to have_css('.icon.icon-small svg') }
    end

    describe 'unknown' do
      let(:size) { 'unknown' }

      it { expect { subject }.to raise_error(ActiveModel::ValidationError) }
    end

    describe 'default size' do
      let(:options) { { icon: icon } }

      it { is_expected.to have_css('.icon.icon-medium svg') }
    end
  end
end
