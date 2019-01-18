class AddMetricGroupToMetrics < ActiveRecord::Migration[5.2]
  def change
    add_reference :metrics, :metric_grouping, foreign_key: true
  end
end
