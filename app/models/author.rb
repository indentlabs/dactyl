class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  has_many :characters, through: :books
  has_many :genres,     through: :books
  has_many :metrics,    through: :books

  extend FriendlyId
  friendly_id :name, use: :slugged
end
