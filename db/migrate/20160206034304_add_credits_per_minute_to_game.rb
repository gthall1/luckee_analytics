class AddCreditsPerMinuteToGame < ActiveRecord::Migration
  def change
    add_column :games, :credits_per_minute, :float
  end
end
