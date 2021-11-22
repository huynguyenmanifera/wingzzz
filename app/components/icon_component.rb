class IconComponent < ViewComponent::Base
  include ActiveModel::Validations

  ALLOWED_SIZES = %i[tiny small medium large].freeze

  validates :size, inclusion: { in: ALLOWED_SIZES }

  def initialize(icon:, size: :medium)
    @icon = icon
    @size = size.to_sym
  end

  private

  attr_reader :icon, :size

  def before_render_check
    validate!
  end

  def icon_classes
    classes = %i[icon]

    classes << size_class
  end

  def size_class
    "icon-#{size}"
  end
end
