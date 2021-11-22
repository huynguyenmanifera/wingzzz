require 'rails_helper'

RSpec.describe AhoyTracker do
  let(:event_name) { 'dummy_event' }
  let(:event_properties) { { my_attr: 'Hello World' } }
  let(:analytics_event) { { name: event_name, properties: event_properties } }
  let(:event_instance) { double('event_instance') }
  let(:ahoy) { double('ahoy') }

  before { allow(ahoy).to receive(:track) }

  describe '#process_analytics_event' do
    context 'existing event' do
      before do
        allow(AnalyticsEvents::Factory).to receive(:create).with(
          event_name,
          event_properties
        )
          .and_return(event_instance)
      end

      context 'valid properties' do
        before { allow(event_instance).to receive(:validate!).and_return(true) }

        it 'is reported to Ahoy' do
          expect(ahoy).to receive(:track).with(event_name, event_properties)

          AhoyTracker.process_analytics_event(ahoy, analytics_event)
        end
      end

      context 'invalid properties' do
        before do
          allow(event_instance).to receive(:validate!).and_raise(
            ActiveRecord::RecordInvalid
          )
        end

        it 'is not reported to Ahoy' do
          expect(ahoy).to_not receive(:track)

          expect {
            AhoyTracker.process_analytics_event(ahoy, analytics_event)
          }.to raise_error(AhoyTracker::EventProcessingError)
        end
      end
    end

    context 'non-existing event' do
      let(:non_existing_event) do
        { name: 'non_existing_event', properties: {} }
      end

      it 'is not reported to Ahoy' do
        expect(ahoy).to_not receive(:track)
        expect {
          AhoyTracker.process_analytics_event(ahoy, non_existing_event)
        }.to raise_error(AhoyTracker::EventProcessingError)
      end
    end
  end
end
