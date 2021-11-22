module MollieWorld
  API_ENDPOINT = 'https://api.mollie.com'.freeze
  API_VERSION = 'v2'.freeze

  def mollie_url(path)
    URI.parse("#{API_ENDPOINT}/#{API_VERSION}/#{path}").to_s
  end

  def mollie_response(name)
    file_fixture("api/mollie/v2/#{name}.json").read
  end
end

World(MollieWorld)
