class AddIdentifierToDactylogram < ActiveRecord::Migration[4.2]
  def change
    add_column :dactylograms, :identifier, :string
  end
end
