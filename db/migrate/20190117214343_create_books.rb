class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :description
      t.datetime :last_indexed

      t.timestamps
    end
  end
end
