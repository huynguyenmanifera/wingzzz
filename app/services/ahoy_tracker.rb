class AhoyTracker
  class << self
    def process_analytics_event(ahoy, props)
      name = props.fetch(:name)
      properties = props.fetch(:properties)

      event = AnalyticsEvents::Factory.create(name, properties)

      ahoy.track name, properties if event.validate!
    rescue StandardError => e
      raise EventProcessingError.new(props, e)
    end
  end

  class EventProcessingError < StandardError
    def initialize(props, error)
      super(
        "Exception occured while processing analytics event: #{
          props
        }.\nCaused by: #{error.inspect}"
      )
    end
  end
end
