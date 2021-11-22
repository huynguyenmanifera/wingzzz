require 'rails_helper'

module AnalyticsEvents
  class DummyEvent
    include ActiveModel::Model
    def self.properties
      []
    end
  end
end

RSpec.describe AnalyticsEvents::Factory do
  describe '#create' do
    context 'when event exists' do
      it 'returns event' do
        expect(
          AnalyticsEvents::Factory.create(
            'dummy_event',
            ActionController::Parameters.new
          )
        ).to be_an_instance_of(AnalyticsEvents::DummyEvent)
      end
    end

    context 'when event does not exist' do
      it 'raises error' do
        expect {
          AnalyticsEvents::Factory.create(
            'non_existing_event',
            ActionController::Parameters.new
          )
        }.to raise_error(AnalyticsEvents::Factory::UnknownEventError)
      end
    end
  end
end
