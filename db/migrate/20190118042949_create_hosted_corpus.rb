class CreateHostedCorpus < ActiveRecord::Migration[5.2]
  def change
    create_table :hosted_corpus do |t|
      t.references :publish_date, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
