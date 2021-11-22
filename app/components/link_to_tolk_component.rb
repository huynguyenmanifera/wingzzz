class LinkToTolkComponent < ViewComponent::Base
  attr_accessor :tolk_url, :engine

  delegate :root_path, to: :engine

  def initialize(tolk_url:, engine:)
    @tolk_url = tolk_url
    @engine = engine
  end

  def url
    if tolk_url.present?
      URI.join(URI.parse(tolk_url), root_path).to_s
    else
      root_path
    end
  end
end
