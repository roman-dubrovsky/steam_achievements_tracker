class AddSteamInfoToUset < ActiveRecord::Migration[8.0]
  def change
    remove_index :users, :email, unique: true
    remove_column :users, :email, :string
    add_column :users, :nickname, :string
    add_column :users, :steam_uid, :string
    add_column :users, :avatar_url, :string
    add_index :users, :steam_uid, unique: true
  end
end
