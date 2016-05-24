class AddUserReferenceToDactylogram < ActiveRecord::Migration
  def change
    add_reference :dactylograms, :user, index: true, foreign_key: true
  end
end
