# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for webhooks', type: :routing do
  it do
    expect(post: '/webhooks/mollie/payment').to route_to(
      controller: 'webhooks/mollie', action: 'payment'
    )
  end

  it do
    expect(post: '/webhooks/mollie/subscription').to route_to(
      controller: 'webhooks/mollie', action: 'subscription'
    )
  end
end
