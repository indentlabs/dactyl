class CreateMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :metrics do |t|
      t.string :name
      t.string :value
      t.references :prose, polymorphic: true

      t.timestamps
    end
  end
end
