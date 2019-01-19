class Genre < ApplicationRecord
  has_many :book_has_genres, dependent: :destroy
  has_many :books,   through: :book_has_genres
  has_many :authors, through: :book_has_genres
end
