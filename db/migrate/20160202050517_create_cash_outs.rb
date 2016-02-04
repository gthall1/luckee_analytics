class CreateCashOuts < ActiveRecord::Migration
  def change
    create_table :cash_outs do |t|
      t.integer :credits_earned
      t.integer :cash
      t.string :cash_out_type
      t.datetime :cash_out_date
      t.integer :user_id
      t.datetime :user_created
      t.integer :user_games_played
      t.integer :user_time_playing
      t.float :user_credits_per_game
      t.float :user_credits_per_minute
      t.string :referal
      t.string :device
      t.integer :arrival_id
      t.datetime :arrival_created
      t.string :user_email

      t.timestamps
    end
  end
end
