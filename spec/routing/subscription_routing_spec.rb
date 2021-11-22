# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for subscription', type: :routing do
  it do
    expect(get: new_subscription_path).to route_to(
      controller: 'subscriptions', action: 'new'
    )
  end

  it 'does or does not route to subscription' do
    expect(get: '/subscription').to be_routable
    expect(get: '/subscription/new').to be_routable
    expect(get: '/subscription/edit').not_to be_routable
    expect(post: '/subscription').to be_routable
    expect(put: '/subscription').not_to be_routable
    expect(delete: '/subscription').not_to be_routable
  end
end
