class CreatePublishDates < ActiveRecord::Migration[5.2]
  def change
    create_table :publish_dates do |t|
      t.date :published_at

      t.timestamps
    end
  end
end
