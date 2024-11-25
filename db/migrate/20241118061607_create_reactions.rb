class CreateReactions < ActiveRecord::Migration[7.2]
    def change
      create_table :emojis do |t|
  
        t.references :post, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
        t.string :name, null: false
  
        t.timestamps
      end
  
      add_index :emojis, [:user_id, :post_id, :type], unique: true
    end
  end