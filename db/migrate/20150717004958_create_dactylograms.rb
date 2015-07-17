class CreateDactylograms < ActiveRecord::Migration
  def change
    create_table :dactylograms do |t|

      t.timestamps null: false
    end
  end
end
