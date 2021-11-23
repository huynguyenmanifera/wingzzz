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
            numericality: {
              only_integer: true, allow_nil: true, greater_than_or_equal_to: 0
            }

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
end
