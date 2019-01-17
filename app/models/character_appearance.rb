class CharacterAppearance < ApplicationRecord
  belongs_to :character
  belongs_to :prose, polymorphic: true
end
