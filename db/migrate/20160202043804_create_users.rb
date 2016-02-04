class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.datetime :user_created
      t.datetime :user_updated
      t.integer :current_credits
      t.integer :credits_from_games
      t.integer :credits_from_surveys
      t.integer :lifetime_credits
      t.boolean :admin
      t.string :zipcode
      t.string :provider
      t.integer :cashed_out_credits
      t.integer :cash_outs
      t.integer :cash_out_value
      t.integer :surveys_complete
      t.integer :arrival_id
      t.string :origin_refer
      t.string :origin_device
      t.string :most_recent_device
      t.integer :game_sessions
      t.integer :unique_games_played
      t.integer :time_spent_playing
      t.integer :visits_to_site
      t.float :credits_per_game
      t.float :credits_per_minute
      t.float :cost_per_minute
      t.float :cost_per_game
      t.timestamps
    end
  end
end
