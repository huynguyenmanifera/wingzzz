class ModalComponent < ViewComponent::Base
  def initialize(size: :small)
    @size = size.to_sym
  end

  def modal_class
    default_modal_classes <<
      case @size
      when :medium
        'max-w-3xl'
      else
        'max-w-xl'
      end
  end

  private

  def default_modal_classes
    %w[
      bg-wz-purple-800
      text-wz-gray-400
      absolute
      mx-auto
      mt-12
      sm:mt-screen/20
      lg:mt-48
      left-0
      right-0
      rounded
      shadow-lg
    ]
  end
end
