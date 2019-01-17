class AddUserReferenceToDactylogram < ActiveRecord::Migration[4.2]
  def change
    add_reference :dactylograms, :user, index: true, foreign_key: true
  end
end
