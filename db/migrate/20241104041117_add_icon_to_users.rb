class AddIconToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :icon, :string
  end
end
