class CreateChapters < ActiveRecord::Migration[5.2]
  def change
    create_table :chapters do |t|
      t.string :title
      t.string :subtitle
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
