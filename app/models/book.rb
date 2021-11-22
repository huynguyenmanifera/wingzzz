require 'book_storage/local'
require 'book_storage/s3'

class Book < ApplicationRecord
  MAX_TITLE_ALLOWED = 255
  SLUG_SEPARATOR = '-'.freeze
  RANDOM_HEX_LENGTH = 4
  LAYOUTS = %w[two_pages single_page].freeze
  TRENDING_NOW_LIMIT = 5
  CURRENTLY_READING_LIMIT = 10
  RECENTLY_ADDED_LIMIT = 10

  enum reader: { default: 0, animated: 1 }, _prefix: true
  enum book_type: { regular: 0, narrated: 1, audio_only: 2 }

  acts_as_taggable_on :keywords

  belongs_to :publisher, optional: true
  has_many :book_sessions, dependent: :destroy
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :authors
  # rubocop:enable Rails/HasAndBelongsToMany
  validates :title, presence: true, length: { maximum: MAX_TITLE_ALLOWED }
  validates :slug, format: { without: /\s/ }
  validates :language,
            presence: true,
            inclusion: { in: I18n.available_locales.collect(&:to_s) }

  validates :layout, presence: true, inclusion: { in: LAYOUTS }
  validates :summary, length: { maximum: 2**10 }
  validates :trending_now_position,
            allow_nil: true, numericality: { greater_than: 0, less_than: 128 }

  before_create :set_slug
  before_validation :set_defaults

  mount_uploader :cover, BookCoverUploader
  mount_uploader :audio, BookAudioUploader

  class << self
    def trending_now(limit = TRENDING_NOW_LIMIT)
      where.not(trending_now_position: nil).order(:trending_now_position).limit(
        limit
      )
    end

    def currently_reading(profile, limit = CURRENTLY_READING_LIMIT)
      joins(:book_sessions).merge(
        BookSession.where(profile: profile).order(updated_at: :desc)
      )
        .limit(limit)
    end

    def recently_added(limit = RECENTLY_ADDED_LIMIT)
      order(created_at: :desc).limit(limit)
    end
  end

  def storage
    @storage ||=
      "BookStorage::#{Wingzzz.config.books[:storage]}".constantize.new(self)
  end

  private

  def set_slug
    self.slug ||= title.parameterize

    while self.class.where(slug: slug).exists?
      limit = MAX_TITLE_ALLOWED - (SLUG_SEPARATOR.length + RANDOM_HEX_LENGTH)
      self.slug =
        [title.first(limit).parameterize, randomhex].join(SLUG_SEPARATOR)
    end
  end

  def randomhex
    SecureRandom.hex(RANDOM_HEX_LENGTH / 2)
  end

  def set_defaults
    self.language ||= I18n.default_locale
    self.layout ||= 'two_pages'
  end
end
