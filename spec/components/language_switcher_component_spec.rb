require 'rails_helper'

RSpec.describe LanguageSwitcherComponent, type: :component do
  let(:instance) { described_class.new }
  let(:html) { render_inline(instance) }
  let(:locales) { %i[en hu nl] }

  subject { Capybara.string(html) }

  before do
    allow(I18n).to receive(:available_locales).and_return(locales)
    allow(I18n).to receive(:locale).and_return(:hu)
    allow(I18n.backend).to receive(:translations).and_return(
      {
        en: { languages: { en: 'English' } },
        hu: { languages: { hu: 'Magyar' } },
        nl: { languages: { nl: 'Nederlands' } }
      }
    )

    allow_any_instance_of(described_class).to receive(:link_to)
      .and_wrap_original do |m, *args|
      name, _options, html_options = args
      m.call(name, '#', html_options)
    end
  end

  it 'renders active links for non-current locales' do
    active_link_css = '.link:not(.pointer-events-none)'

    is_expected.to have_css(active_link_css, text: 'English')
    is_expected.to have_css(active_link_css, text: 'Nederlands')
  end

  it 'render non-active link for current locale' do
    inactive_link_css = '.link.pointer-events-none'

    is_expected.to have_css(inactive_link_css, text: 'Magyar')
  end
end
