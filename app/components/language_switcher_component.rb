class LanguageSwitcherComponent < ViewComponent::Base
  include UrlForHelper

  attr_reader :dark_mode

  def initialize(dark_mode: false)
    @dark_mode = dark_mode
  end

  def link_to_locale(locale)
    link_to language_in_own_language(locale),
            url_for_options_w_fallback(locale: locale),
            class: link_classes(locale)
  end

  def language_in_own_language(locale)
    I18n.backend.translations[locale][:languages][locale]
  end

  def link_classes(locale)
    classes = %w[link]
    classes << 'pointer-events-none' if current_locale?(locale)
    classes << 'opacity-50' unless current_locale?(locale)

    classes << 'text-wz-white' if @dark_mode
    classes
  end

  def current_locale?(locale)
    I18n.locale == locale
  end
end
