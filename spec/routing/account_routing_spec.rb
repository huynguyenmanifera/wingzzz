# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for account', type: :routing do
  it do
    expect(post: unsubscribe_account_path).to route_to(
      controller: 'account/accounts', action: 'unsubscribe'
    )
  end
end
