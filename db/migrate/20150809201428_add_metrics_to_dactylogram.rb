class AddMetricsToDactylogram < ActiveRecord::Migration[4.2]
  def change
    add_column :dactylograms, :metrics, :string
  end
end
