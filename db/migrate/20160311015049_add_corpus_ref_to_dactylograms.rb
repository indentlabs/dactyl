class AddCorpusRefToDactylograms < ActiveRecord::Migration[4.2]
  def change
    add_reference :dactylograms, :corpus, index: true
    add_foreign_key :dactylograms, :corpus
  end
end
