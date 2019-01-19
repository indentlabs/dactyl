class Publisher < ApplicationRecord
  has_many :books, dependent: :destroy
  has_many :authors, through: :books
  has_many :metrics, through: :books
  has_many :genres,  through: :books

  has_many :publish_dates, dependent: :destroy
end
