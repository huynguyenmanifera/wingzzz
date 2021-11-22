Mollie::Client.configure do |config|
  config.api_key = Wingzzz.config.mollie[:api_key]
  # Timeouts (default - 60)
  # config.open_timeout = 60
  # config.read_timeout = 60
end
