class Character < ApplicationRecord
  has_many :character_appearances, dependent: :destroy
  has_many :books, through: :character_appearances,
    source: :prose, source_type: Book.name
  has_many :chapters, through: :character_appearances,
    source: :prose, source_type: Chapter.name

  has_many :metrics, dependent: :destroy
end
