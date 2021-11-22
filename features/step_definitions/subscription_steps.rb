Then('I expect to see a page telling me I do not have a subscription yet') do
  expect(page).to have_content('Activate your subscription')
  expect(page).to have_button('Activate my subscription')
  expect(current_path).to eql(new_subscription_path)
end

When('I cancel my subscription flow') { click_on('Login as a different user') }

When('I continue setting up my subscription') do
  customers_response = { id: 'customer_id' }
  checkout_href = 'www.mollie.com/payscreen/select-method'
  payments_response = { _links: { checkout: { href: checkout_href } } }

  stub_request(:get, checkout_href)

  # See: https://docs.mollie.com/reference/v2/customers-api/create-customer
  stub_request(:post, 'https://api.mollie.com/v2/customers').to_return(
    body: customers_response.to_json
  )

  # See: https://docs.mollie.com/reference/v2/payments-api/create-payment
  stub_request(:post, 'https://api.mollie.com/v2/payments').to_return(
    body: payments_response.to_json
  )

  step('I click "Activate my subscription"')
end

When('I abort when on the payment page') {}

Then('I expect to see a page telling me I was setting up my subscription') do
  expect(page).to have_content('Subscription has not been completed')
  expect(page).to have_button('Activate my subscription')
  expect(current_path).to eql(new_subscription_path)
end

When('I submit my payment details') do
  customer_id = 'customer_id'
  payments_response = {
    customer_id: customer_id,
    metadata: { wz_user_id: User.last.id },
    status: 'paid'
  }
  mandates_response = { status: 'valid' }
  subscriptions_response = {}

  # See: https://docs.mollie.com/reference/v2/payments-api/get-payment
  stub_request(:get, %r{https://api.mollie.com/v2/payments/}).to_return(
    body: payments_response.to_json
  )

  # See: https://docs.mollie.com/reference/v2/mandates-api/get-mandate
  stub_request(
    :get,
    "https://api.mollie.com/v2/customers/#{customer_id}/mandates"
  )
    .to_return(body: mandates_response.to_json)

  # See: https://docs.mollie.com/reference/v2/subscriptions-api/create-subscription
  stub_request(
    :post,
    "https://api.mollie.com/v2/customers/#{customer_id}/subscriptions"
  )
    .to_return(body: subscriptions_response.to_json)

  post webhooks_mollie_payment_path, id: 'payment_id'
end

When('Mollie returns me to the Wingzzz application') { visit root_path }
