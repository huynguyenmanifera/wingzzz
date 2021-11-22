module Page
  class FooterComponent < ViewComponent::Base
    include ApplicationHelper

    def initialize(dark_mode: false)
      @dark_mode = dark_mode
    end

    def external_links_keys
      %i[privacy_policy contact terms_of_use]
    end

    def link_classes
      classes = %w[link]
      classes << (@dark_mode ? 'link-transparent' : 'opacity-75')
      classes
    end

    def copyright_notice
      "&copy; Wingzzz B.V. #{I18n.t('all_rights_reserved')}".html_safe # rubocop:disable Rails/OutputSafety
    end

    def copyright_notice_classes
      @dark_mode ? 'text-wz-white-trn-500' : 'text-wz-gray-600'
    end
  end
end
