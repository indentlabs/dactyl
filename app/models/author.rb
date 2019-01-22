class Author < ApplicationRecord
  has_many :publish_dates, dependent: :destroy
  has_many :books,      through: :publish_dates
  has_many :characters, through: :books
  has_many :genres,     through: :books
  has_many :metrics,    through: :books

  extend FriendlyId
  friendly_id :name, use: :slugged
end
