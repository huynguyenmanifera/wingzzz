require 'webmock/cucumber'

WebMock.disable_net_connect!(
  allow_localhost: true, allow: 'chromedriver.storage.googleapis.com'
)

Before do |_scenario|
  stub_request(:get, %r{#{mollie_url('customers')}/\w+}).to_return(
    body: mollie_response('get-customer')
  )

  stub_request(:get, %r{#{mollie_url('customers')}/\w+/mandates}).to_return(
    body: mollie_response('list-mandates')
  )

  stub_request(:get, %r{#{mollie_url('customers')}/\w+/subscriptions/\w+})
    .to_return(body: mollie_response('get-subscription'))

  stub_request(:delete, %r{#{mollie_url('customers')}/\w+/subscriptions/\w+})
    .to_return(body: {}.to_json)

  stub_request(:delete, %r{#{mollie_url('customers')}/\w+/mandates/\w+})
    .to_return(body: {}.to_json)
end
