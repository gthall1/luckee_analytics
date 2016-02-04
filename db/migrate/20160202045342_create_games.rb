class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :slug
      t.integer :sort_order
      t.integer :previous_sort_order
      t.string :sort_order_hash
      t.datetime :sort_order_changed
      t.datetime :game_added
      t.integer :total_credits_earned
      t.integer :device_type
      t.integer :total_games_played
      t.integer :total_time_spent_on_game
      t.float :credits_per_game
      t.float :time_per_game
      t.float :cost_per_game
      t.float :cost_per_minute
      t.float :avg_score
      t.integer :total_users_who_played

      t.timestamps
    end
  end
end
