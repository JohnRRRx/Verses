# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :photo, null: false
      t.string :song_id
      t.string :song_name
      t.string :artist_name
      t.string :album_name
      t.string :audio
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
