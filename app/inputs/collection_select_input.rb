class CollectionSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input(wrapper_options = nil)
    wz_wrapper_html = input_html_options.delete(:wz_wrapper_html) || {}

    template.tag.div({ class: class_names }.merge(wz_wrapper_html)) do
      template.concat super
      template.concat caret
    end
  end

  private

  def class_names
    result = [block_name]
    result << %w[disabled] if input_html_options[:disabled]
    result
  end

  def caret
    element_name = 'caret'
    template.tag.div(class: "#{block_name}__#{element_name}") do
      template.tag.div('', class: "#{block_name}__#{element_name}__icon")
    end
  end

  def block_name
    'select-box'
  end
end
