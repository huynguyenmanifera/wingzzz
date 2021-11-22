class IconComponentPreview < ViewComponent::Preview
  layout 'preview'

  IconComponent::ALLOWED_SIZES.each do |size|
    define_method "with_#{size}" do
      self.size = size
      render_component
    end
  end

  private

  attr_accessor :size

  def render_component
    render(IconComponent.new(options))
  end

  def options
    { icon: 'book', size: size }
  end
end
