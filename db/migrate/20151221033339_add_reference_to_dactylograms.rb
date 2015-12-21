class AddReferenceToDactylograms < ActiveRecord::Migration
  def change
    add_column :dactylograms, :reference, :string
  end
end
