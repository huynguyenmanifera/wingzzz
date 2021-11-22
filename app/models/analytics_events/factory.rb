module AnalyticsEvents
  class Factory
    class << self
      def create(name, properties)
        create_instance!(name, properties)
      end

      private

      def create_instance!(name, properties)
        event_class = "AnalyticsEvents::#{name.camelize}".constantize
        event_class.new(properties.permit(event_class.properties))
      rescue NameError => e
        raise UnknownEventError.new(name, e)
      end
    end

    class UnknownEventError < StandardError
      def initialize(name, error)
        super(
          "Could not find event class for event with name '#{
            name
          }'.\nCaused by: #{error.inspect}"
        )
      end
    end
  end
end
