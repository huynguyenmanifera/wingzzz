class SearchInputComponent < ViewComponent::Base
  attr_reader :name
  attr_reader :value

  def initialize(props = {})
    @name = props.fetch(:name, nil)
    @value = props.fetch(:value, '')
  end
end
