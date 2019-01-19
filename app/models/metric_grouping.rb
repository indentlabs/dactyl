class MetricGrouping < ApplicationRecord
  belongs_to :prose, polymorphic: true
  has_many :metrics, dependent: :destroy
end
