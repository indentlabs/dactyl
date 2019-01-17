class CreateBookHasGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :book_has_genres do |t|
      t.references :book, foreign_key: true
      t.references :genre, foreign_key: true

      t.timestamps
    end
  end
end
