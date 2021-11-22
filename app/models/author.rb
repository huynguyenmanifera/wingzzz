class Author < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :books, dependent: :nullify
  # rubocop:enable Rails/HasAndBelongsToMany
end
