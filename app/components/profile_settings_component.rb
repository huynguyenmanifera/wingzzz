class ProfileSettingsComponent < ViewComponent::Base
  include ApplicationHelper

  AGE_RANGE_YEARS = [0.5, 1, 1.5, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].freeze

  BOOK_TYPE = { "Regular": 0, "Narrated": 1, "Audio Only": 2 }

  attr_reader :profile

  def initialize(profile:)
    @profile = profile.decorate
  end

  def min_age_in_months_collection
    [[label_for_years(0), nil]] + age_in_months_collection
  end

  def max_age_in_months_collection
    age_in_months_collection + [[t('age_range.years_and_over', count: 12), nil]]
  end

  def language_collection
    I18n.available_locales.map { |locale| [t("languages.#{locale}"), locale] }
  end

  private

  def label_for_years(years)
    use_months = years < 2
    if use_months
      t('age_range.month', count: months_for_years(years))
    else
      t('age_range.year', count: years)
    end
  end

  def months_for_years(years)
    (years * 12).to_i
  end

  def age_in_months_collection
    AGE_RANGE_YEARS.map do |years|
      [label_for_years(years), months_for_years(years)]
    end
  end
end
