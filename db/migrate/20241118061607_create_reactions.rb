class CreateReactions < ActiveRecord::Migration[7.2]
  def change
    create_table :reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.string :emoji, null: false

      t.timestamps
    end
    add_index :reactions, %i[user_id post_id emoji], unique: true
  end
end
