class AddCorpusRefToDactylograms < ActiveRecord::Migration
  def change
    add_reference :dactylograms, :corpus, index: true
    add_foreign_key :dactylograms, :corpus
  end
end
