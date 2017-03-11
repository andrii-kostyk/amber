class CreateClouds < ActiveRecord::Migration
  def change
    create_table :clouds do |t|
      t.string :host
      t.string :name
      t.string :user
      t.string :password
      t.string :token

      t.timestamps null: false
    end
  end
end
