class Metric < ApplicationRecord
  belongs_to :prose, polymorphic: true
end
