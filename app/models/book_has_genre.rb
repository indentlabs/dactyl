class BookHasGenre < ApplicationRecord
  belongs_to :book
  belongs_to :genre
end
