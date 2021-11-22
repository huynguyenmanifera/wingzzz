require 'rails_helper'

RSpec.describe ModalComponent, type: :component do
  subject { Capybara.string(html) }

  let(:html) { render_inline(instance) { content } }
  let(:instance) { described_class.new(options) }
  let(:options) { { size: size } }
  let(:size) { :small }
  let(:content) { 'Lorem Ipsum' }

  describe 'backdrop' do
    it { is_expected.to have_css('.w-screen.h-screen.fixed.left-0.top-0') }

    it do
      is_expected.to have_css(
        '.w-screen > .w-full.h-full.absolute.top-0.bg-wz-black.bg-opacity-50'
      )
    end
  end

  describe 'modal' do
    it 'has a fixed top' do
      is_expected.to have_css(
        '.w-screen > .absolute.mx-auto.left-0.right-0.rounded.shadow-lg.mt-12'
      )
    end

    it 'has a close button' do
      is_expected.to have_css('.bg-wz-purple-800 button .icon.icon-tiny svg')
    end

    it do
      is_expected.to have_css('.bg-wz-purple-800 .h-full.p-10', text: content)
    end
  end

  describe 'Stimulus' do
    it { is_expected.to have_css('[data-controller="modal"]') }

    it 'closes when clicking on backdrop' do
      is_expected.to have_css('.w-screen > [data-action="click->modal#close"]')
    end

    it 'closes when clicking on close button' do
      is_expected.to have_css(
        '.w-screen button[data-action="click->modal#close"]'
      )
    end
  end

  describe 'small' do
    let(:size) { :small }

    it { is_expected.to have_css('.w-screen > .max-w-xl') }
  end

  describe 'medium' do
    let(:size) { :medium }

    it { is_expected.to have_css('.w-screen > .max-w-3xl') }
  end
end
