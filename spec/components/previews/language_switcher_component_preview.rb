class LanguageSwitcherComponentPreview < ViewComponent::Preview
  layout 'preview'

  def default
    render(LanguageSwitcherComponent.new)
  end
end
