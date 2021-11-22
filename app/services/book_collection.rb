class BookCollection
  attr_reader :filters, :profile

  def initialize(filters, profile)
    @profile = profile
    self.filters = filters
  end

  def self.from_filters(filters, profile)
    new filters, profile
  end

  def results_current_language
    @results_current_language ||= search ransack_params_current_language
  end

  def results_other_languages
    @results_other_languages ||= search ransack_params_other_languages
  end

  def query
    query = filters.fetch(:q, nil)
    query = nil if query&.empty?
    query
  end

  private

  def filters=(new_value)
    @filters =
      if new_value.respond_to?(:to_unsafe_h)
        new_value.to_unsafe_h
      else
        Hash(new_value)
      end
  end

  def search(ransack_params)
    search = Book.includes(:publisher, :authors).ransack(ransack_params)
    search.sorts = 'title'
    search.result(distinct: true)
  end

  def ransack_params
    {
      title_or_publisher_name_or_authors_name_or_keywords_name_i_cont:
        filters.fetch(:q, nil)
    }.merge age_range_params
  end

  def ransack_params_current_language
    ransack_base_params.merge language_eq: profile.content_language
  end

  def ransack_params_other_languages
    ransack_base_params.merge language_not_eq: profile.content_language
  end

  def ransack_base_params
    {
      title_or_publisher_name_or_authors_name_or_keywords_name_i_cont: query
    }.merge(age_range_params)
      .compact
  end

  def age_range_params
    if profile.min_age_in_months == profile.max_age_in_months
      {
        min_age_in_months_lteq: profile.max_age_in_months,
        max_age_in_months_gteq: profile.min_age_in_months
      }
    else
      {
        min_age_in_months_lt: profile.max_age_in_months,
        max_age_in_months_gt: profile.min_age_in_months
      }
    end
  end
end
