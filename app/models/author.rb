class Author < ApplicationRecord
  has_many :books
  has_many :characters, through: :books
  has_many :genres,     through: :books
  has_many :metrics,    through: :books
end
