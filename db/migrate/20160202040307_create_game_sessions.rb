class CreateGameSessions < ActiveRecord::Migration
  def change
    create_table :game_sessions do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :credits_earned
      t.integer :score
      t.boolean :active
      t.integer :arrival_id
      t.string :browser
      t.string :landing_page
      t.string :referer
      t.string :platform
      t.string :user_name
      t.string :game_name
      t.string :user_provider
      t.integer :time_played
      t.float :credits_per_minute
      t.float :cost_per_minute
      t.datetime :user_created
      t.datetime :game_session_created
      t.datetime :game_session_updated

      t.timestamps
    end
  end
end
