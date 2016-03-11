class CreateCorpus < ActiveRecord::Migration
  def change
    create_table :corpus do |t|
      t.string :text

      t.timestamps null: false
    end
  end
end
