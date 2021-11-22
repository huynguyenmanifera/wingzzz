require 'administrate/base_dashboard'

class BookDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    publisher: Field::BelongsTo,
    authors: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    slug: Field::String,
    min_age_in_months: Field::Number,
    max_age_in_months: Field::Number,
    language: Field::String,
    layout: Field::Select.with_options(collection: Book::LAYOUTS),
    cover: ImageField,
    summary: Field::Text,
    book_type: Field::Enum,
    audio: FileUploaderField,
    trending_now_position: Field::Number,
    reader: Field::Enum,
    keywords: Field::ActsAsTaggable
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    title
    publisher
    authors
    language
    min_age_in_months
    max_age_in_months
    trending_now_position
    book_type
    reader
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    title
    publisher
    authors
    language
    layout
    created_at
    updated_at
    slug
    min_age_in_months
    max_age_in_months
    summary
    book_type
    audio
    trending_now_position
    reader
    keywords
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    title
    publisher
    authors
    language
    layout
    min_age_in_months
    max_age_in_months
    cover
    summary
    book_type
    audio
    trending_now_position
    reader
    keywords
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how books are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(book)
    book.title.truncate(30)
  end
end
