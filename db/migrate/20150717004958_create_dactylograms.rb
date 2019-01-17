class CreateDactylograms < ActiveRecord::Migration[4.2]
  def change
    create_table :dactylograms do |t|

      t.timestamps null: false
    end
  end
end
