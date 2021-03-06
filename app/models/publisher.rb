class Publisher < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :books, dependent: :nullify
end
