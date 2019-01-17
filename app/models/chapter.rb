class Chapter < ApplicationRecord
  belongs_to :book

  has_many :character_appearances
  has_many :characters, through: :character_appearances

  has_many :metrics, as: :prose
end
