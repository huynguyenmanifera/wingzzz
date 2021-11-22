module SectionedForm
  class InputPreviewComponent < ViewComponent::Base
    attr_reader :label

    def initialize(label:)
      @label = label
    end
  end
end
