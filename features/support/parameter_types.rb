ParameterType(
  name: 'book',
  regexp: /(?:book\s\")(.*)(?:\")/,
  transformer: ->(title) { Book.find_by(title: title) }
)
