class CreateCharacterAppearances < ActiveRecord::Migration[5.2]
  def change
    create_table :character_appearances do |t|
      t.references :character, foreign_key: true
      t.references :prose, polymorphic: true

      t.timestamps
    end
  end
end
