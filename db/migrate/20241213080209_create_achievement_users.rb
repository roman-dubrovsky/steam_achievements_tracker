class CreateAchievementUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :achievement_users do |t|
      t.references :achievement, null: false, index: true
      t.references :game_user, null: false, index: true
      t.boolean :completed, default: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
