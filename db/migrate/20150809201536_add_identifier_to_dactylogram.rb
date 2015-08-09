class AddIdentifierToDactylogram < ActiveRecord::Migration
  def change
    add_column :dactylograms, :identifier, :string
  end
end
