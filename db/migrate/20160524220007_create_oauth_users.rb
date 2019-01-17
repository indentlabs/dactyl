class CreateOauthUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :oauth_users do |t|

      t.timestamps null: false
    end
  end
end
