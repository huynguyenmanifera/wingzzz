module UrlForHelper
  WZ_FALLBACK_LOCATION = :wz_fallback_location

  # When a submitted form ends up with a validation error
  # some URLs may end up wrong. E.g. the URLs
  # for switching to a different language will contain
  # the path to the POST or UPDATE endpoint.
  # In that case, you need to create a link_to
  # with this `url_for_options_w_fallback` helper
  # for composing the options pased to the `link_to` helper.
  #
  # @example
  #  = link_to locale.upcase, url_for_options_w_fallback(locale: locale)
  #
  def url_for_options_w_fallback(options)
    case action_name
    when /(create|update)/
      url = session[WZ_FALLBACK_LOCATION] || root_url
      compose_url(url, options)
    else
      store_fallback_location
      options
    end
  end

  private

  def compose_url(url, options)
    uri = URI.parse(url)
    query = Rack::Utils.parse_query(uri.query).with_indifferent_access
    query.merge!(options)

    uri.query = Rack::Utils.build_query(query)
    uri.to_s
  end

  def store_fallback_location
    session[WZ_FALLBACK_LOCATION] = request.env['REQUEST_PATH']
  end
end
