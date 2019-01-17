class CreatePublishDates < ActiveRecord::Migration[5.2]
  def change
    create_table :publish_dates do |t|
      t.date :published_at
      t.references :publisher, foreign_key: true
      t.references :author, foreign_key: true
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
