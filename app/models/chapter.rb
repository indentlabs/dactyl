class Chapter < ApplicationRecord
  belongs_to :book

  has_many :character_appearances, dependent: :destroy
  has_many :characters, through: :character_appearances

  has_many :metric_groupings, as: :prose, dependent: :destroy
  has_many :metrics, through: :metric_groupings
end
