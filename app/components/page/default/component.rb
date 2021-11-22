module Page
  module Default
    class Component < ViewComponent::Base
      with_content_areas :header

      include ApplicationHelper

      def initialize(show_background_image: true)
        @show_background_image = show_background_image
      end

      def background_style
        # This color corresponds to the color of the very bottom of the
        # current background image. When scrolling down, the image stops
        # and transitions into this solid color.
        style = 'background-color: #010F2C;'

        return style unless @show_background_image

        style +
          "background-image: url(#{
            image_url('background.jpg')
          }); background-size: 100%; min-width: 500px;"
      end
    end
  end
end
