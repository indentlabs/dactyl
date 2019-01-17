class Book < ApplicationRecord
  has_many :book_has_genres
  has_many :genres, through: :book_has_genres

  has_many :publish_dates
  has_many :publishers, through: :publish_dates
  has_many :authors,    through: :publish_dates

  has_many :chapters

  has_many :character_appearances
  has_many :characters, through: :character_appearances

  has_many :metrics, as: :prose
end
