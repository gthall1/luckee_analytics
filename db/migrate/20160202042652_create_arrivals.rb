class CreateArrivals < ActiveRecord::Migration
  def change
    create_table :arrivals do |t|
      t.string :landing_url
      t.string :ip
      t.integer :user_id
      t.string :user_name
      t.string :user_email
      t.datetime :user_created
      t.datetime :arrival_created
      t.integer :mobile
      t.string :device
      t.string :referer
      t.string :user_agent
      t.string :platform
      t.string :browser
      t.string :version
      t.boolean :signup
      t.integer :games_played
      t.integer :credits_earned
      t.integer :cash_out_count
      t.integer :cash_out_value
      t.integer :surveys_taken
      
      t.timestamps
    end
  end
end
