class CreateMetricGroupings < ActiveRecord::Migration[5.2]
  def change
    create_table :metric_groupings do |t|
      t.string :name
      t.references :prose, polymorphic: true

      t.timestamps
    end
  end
end
