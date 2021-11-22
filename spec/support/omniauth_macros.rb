module OmniauthMacros
  def mock_auth_hash(provider)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[provider.to_sym] = {
      'provider' => provider,
      'uid' => '123545',
      'info' => { 'email' => 'omniuser@example.org', 'name' => 'mockuser' },
      'credentials' => { 'token' => 'mock_token', 'secret' => 'mock_secret' }
    }
  end
end

RSpec.configure { |config| config.include OmniauthMacros }
