class AddMetricsToDactylogram < ActiveRecord::Migration
  def change
    add_column :dactylograms, :metrics, :string
  end
end
