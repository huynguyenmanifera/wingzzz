SimpleForm.setup do |config|
  config.wrappers(
    :wz_default,
    tag: :label, class: 'input-wrapper', error_class: 'input-wrapper--invalid'
  ) do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :wz_label, tag: :div, class: 'input-label' do |c|
      c.use :label_text
    end

    b.use :hint, wrap_with: { class: 'input-hint' }
    b.use :input, class: 'input'
    b.use :full_error, wrap_with: { class: 'input-error' }
  end

  config.wrappers(:wz_boolean, error_class: 'input-wrapper--invalid') do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper :wz_wrapper, tag: :label, class: 'checkbox' do |c|
      c.use :input, class: 'checkbox__input'
      c.wrapper tag: :span, class: 'checkbox__box' do |d|
        d.wrapper tag: :span, class: 'checkbox__box__mark' do |e|
        end
      end
      c.wrapper :wz_label, tag: :span, class: 'checkbox__label' do |d|
        d.use :label_text
      end
    end

    # TODO: How to show errors?
  end

  config.wrappers(
    :wz_select,
    tag: :label, class: 'input-wrapper', error_class: 'input-wrapper--invalid'
  ) do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :wz_label, tag: :div, class: 'input-label' do |c|
      c.use :label_text
    end

    b.use :hint, wrap_with: { class: 'input-hint' }

    # Wrapping is done by the custom CollectionSelectInput
    # since we need a dynamic wrapper classname.
    b.use :input, class: 'select-box__select'
    b.use :full_error, wrap_with: { class: 'input-error' }
  end

  config.label_text = lambda do |label, required, explicit_label|
    "#{label} #{required}"
  end

  config.boolean_style = :inline
  config.default_wrapper = :wz_default
  config.wrapper_mappings = { boolean: :wz_boolean, select: :wz_select }
end
