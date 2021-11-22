module Page
  module Bare
    class Component < ViewComponent::Base
      include ApplicationHelper

      attr_reader :dark_mode

      def initialize(dark_mode: false)
        @dark_mode = dark_mode
      end

      def background_style
        @dark_mode ? dark_background_style : light_background_style
      end

      def dark_background_style
        "background-image: url(#{
          image_url('background_dark.jpg')
        }); background-size: 100%; min-width: 500px; background-color: #01102d;"
      end

      def light_background_style
        "background-image: url(#{
          image_url('background_light.jpg')
        }); background-size: 100%; min-width: 500px; background-color: #fff;"
      end
    end
  end
end
