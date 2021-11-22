module ApplicationHelper
  def current_profile
    return nil unless current_user

    # TODO: retrieve current profile from session when we
    # start supporting multiple profiles.
    current_user.profiles&.first
  end

  def external_link_to(key, html_options = {})
    html_options.merge! rel: 'noopener noreferrer', target: '_blank'

    external_url = Wingzzz.config.external_urls.fetch(key)
    name = t(key).upcase_first

    link_to(name, external_url, html_options)
  end

  def link_to_tolk
    render(
      LinkToTolkComponent.new(tolk_url: Wingzzz.config.tolk[:url], engine: tolk)
    )
  end

  def link_to_pdf_to_epub_converter
    external_link_to(:pdf_to_epub_converter, class: 'link')
  end

  def search_input(props = {})
    render(SearchInputComponent.new(props))
  end

  def flash_messages(type: nil)
    # It's not possible to disable certain flash messages for the device gem.
    # In order to hide these, we configure an empty string in the translations
    # file and filter them out here
    messages = flash.filter { |_, message| !message.empty? }

    if type
      types = type.is_a?(Array) ? type : [type] if type
      messages =
        messages.filter do |message_type, _message|
          types.include?(message_type.to_sym)
        end
    end

    messages
  end
end
