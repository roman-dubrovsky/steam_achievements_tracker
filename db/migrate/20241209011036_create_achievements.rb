class CreateAchievements < ActiveRecord::Migration[8.0]
  def change
    create_table :achievements do |t|
      t.references :game, null: false, index: true
      t.string :uid
      t.string :name
      t.boolean :hidden, null: false, default: false
      t.text :description
      t.text :notes
      t.string :icon
      t.string :icongray

      t.timestamps
    end
  end
end
