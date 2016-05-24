class CreateOauthUsers < ActiveRecord::Migration
  def change
    create_table :oauth_users do |t|

      t.timestamps null: false
    end
  end
end
