class LinksTable < ActiveRecord::Migration
  def change
    create_table :urls do |u|
      u.integer :user_id
      u.string :url
      u.string :short_url
      u.integer :click_count, default: 0
      u.timestamps null: false
    end
  end
end
