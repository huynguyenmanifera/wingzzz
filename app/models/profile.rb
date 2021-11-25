class Profile < ApplicationRecord
  belongs_to :user

  validates :min_age_in_months,
            :max_age_in_months,
            numericality: {
              only_integer: true, allow_nil: true, greater_than_or_equal_to: 0
            }

  validate :min_age_cannot_be_greater_than_max_age,
           if: :min_and_max_age_present?

  validates :content_language,
            presence: true,
            inclusion: { in: I18n.available_locales.collect(&:to_s) }

  validates :book_type,
            presence: true,
            numericality: {
              only_integer: true, allow_nil: false
            }

  validate :is_valid_book_type

  before_validation :set_content_language

  private

  def min_age_cannot_be_greater_than_max_age
    return if min_age_in_months <= max_age_in_months

    errors.add(
      :max_age_in_months,
      :greater_than_or_equal_to,
      count: min_age_in_months
    )
  end

  def min_and_max_age_present?
    min_age_in_months && max_age_in_months
  end

  def set_content_language
    self.content_language ||= I18n.locale
  end

  def is_valid_book_type
    list_book_types = []
    Book.book_types.each { |key, value| 
      list_book_types << value
    }
    return if list_book_types.include?(book_type)
    errors.add(
      :book_type,
      :less_than_or_equal_to,
      count: list_book_types.last
    )
  end 
end
