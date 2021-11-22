module AnalyticsEvents
  class BookProgressChange
    include ActiveModel::Model

    def self.properties
      %i[book_id book_opened_at previous_progress new_progress].freeze
    end

    attr_accessor :book_id, :book_opened_at, :previous_progress, :new_progress

    validates :book_id,
              numericality: { only_integer: true, greater_than_or_equal_to: 1 },
              presence: true

    validates :book_opened_at,
              numericality: { only_integer: true, greater_than_or_equal_to: 1 },
              presence: true

    validates :previous_progress,
              numericality: {
                greater_than_or_equal_to: 0, less_than_or_equal_to: 1
              },
              presence: true

    validates :new_progress,
              numericality: {
                greater_than_or_equal_to: 0, less_than_or_equal_to: 1
              },
              presence: true
  end
end
