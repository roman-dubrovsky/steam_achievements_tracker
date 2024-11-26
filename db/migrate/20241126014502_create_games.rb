class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :app_uid

      t.timestamps
    end

    add_index :games, :app_uid, unique: true
  end
end
