class CreateTotalData < ActiveRecord::Migration
  def change
    create_table :total_data do |t|
      t.datetime :date
      t.integer :arrivals
      t.integer :users
      t.integer :cash_outs
      t.integer :surveys
      t.integer :games_played
      t.integer :credits_earned
      t.integer :cash_payed_out
      t.integer :time_spent_playing
      t.integer :mobile_arrivals
      t.integer :desktop_arrivals
      t.float :credits_per_minute
      t.float :cost_per_minute
      t.float :games_per_arrival
      t.timestamps
    end
  end
end
