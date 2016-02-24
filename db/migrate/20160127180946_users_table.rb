class UsersTable < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string :name
      u.string :email
      u.string :pwd
      u.timestamps null: false
    end
  end
end

