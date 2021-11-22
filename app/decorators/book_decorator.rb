class BookDecorator < ApplicationDecorator
  include ActionView::Helpers::AssetUrlHelper

  delegate_all

  delegate :epub_url, to: :storage

  TODDLER_AGE = 2
  TEEN_AGE = 12

  def formatted_age_range
    return I18n.t('age_range.all_ages') if infinite_range?

    [left_label, right_label].join(' - ')
  end

  def show_authors
    authors = []
    self.authors.each { |author| authors.push author.name }
    authors.join(', ')
  end

  private

  def infinite_range?
    infinite_left? && infinite_right?
  end

  def infinite_left?
    min_age_in_months.blank?
  end

  def infinite_right?
    max_age_in_months.blank?
  end

  def left_label
    return min_age_in_months.to_i if infinite_left? || min_age_in_months.zero?

    if (infinite_right? || !toddler?(max_age_in_months)) &&
         toddler?(min_age_in_months)
      I18n.t('age_range.month', count: min_age_in_months)
    else
      left_value
    end
  end

  def left_value
    if toddler?(min_age_in_months)
      min_age_in_months
    else
      in_years(min_age_in_months)
    end
  end

  def right_label
    if infinite_right?
      return I18n.t('age_range.years_and_over', count: TEEN_AGE)
    end

    if toddler?(max_age_in_months)
      I18n.t('age_range.month', count: right_value)
    else
      I18n.t('age_range.year', count: right_value)
    end
  end

  def right_value
    if toddler?(max_age_in_months)
      max_age_in_months
    else
      in_years(max_age_in_months)
    end
  end

  def toddler?(age_in_months)
    in_years(age_in_months) < TODDLER_AGE
  end

  def in_years(months)
    months / 12
  end
end
