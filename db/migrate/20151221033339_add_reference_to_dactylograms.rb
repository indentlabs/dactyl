class AddReferenceToDactylograms < ActiveRecord::Migration[4.2]
  def change
    add_column :dactylograms, :reference, :string
  end
end
