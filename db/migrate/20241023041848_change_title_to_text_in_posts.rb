class ChangeTitleToTextInPosts < ActiveRecord::Migration[7.2]
  def change
    change_column :posts, :title, :text
  end
end
