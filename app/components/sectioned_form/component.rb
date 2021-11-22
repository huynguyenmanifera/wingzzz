module SectionedForm
  class Component < ViewComponent::Base
    include UrlForHelper

    attr_reader :title

    def initialize(title:)
      @title = title
    end
  end
end
