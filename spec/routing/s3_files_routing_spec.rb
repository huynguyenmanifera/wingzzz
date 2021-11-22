# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for s3 files', type: :routing do
  describe 'GET /s3_files' do
    it do
      expect(get('s3_files/lorem/ipsum')).to route_to(
        's3_files#show',
        key: 'lorem/ipsum'
      )
    end

    it do
      expect(get: s3_file_path('lorem/ipsum')).to route_to(
        's3_files#show',
        key: 'lorem/ipsum'
      )
    end
  end
end
